# Animating Git visualizations with camcorder

The data visualization functions in `ghreadme` return `ggplot` objects,
which means each call can be recorded as a frame with the
[`camcorder`](https://thebioengineer.r-universe.dev/camcorder) package
and stitched into an animated GIF with
[`gifski`](https://github.com/r-rust/gifski). This vignette walks
through three patterns for turning a single static plot into an
animation that highlights how your commit activity evolves over time.

## Prerequisites

``` r

install.packages(c("camcorder", "gifski"))
```

The recipes below also assume the data-collection and ggplot-based plot
helpers from `ghreadme`:

``` r

library(ghreadme)
library(camcorder)

commits <- collect_git_commits(
  user   = "mjfrigaard",
  emails = c("mjfrigaard@pm.me", "mjfrigaard@gmail.com")
)
```

## How `camcorder` works

[`camcorder::gg_record()`](https://rdrr.io/pkg/camcorder/man/Recording.html)
registers a hook so that **every** ggplot you
[`print()`](https://rdrr.io/r/base/print.html) is also written to a PNG
inside a temporary directory. After the loop finishes,
[`camcorder::gg_playback()`](https://rdrr.io/pkg/camcorder/man/Recording.html)
reads those PNGs back in order and writes them to a single GIF. The
pattern is always:

1.  Call
    [`gg_record()`](https://rdrr.io/pkg/camcorder/man/Recording.html)
    once to start recording.
2.  Loop, building one ggplot per frame and printing it.
3.  Call
    [`gg_playback()`](https://rdrr.io/pkg/camcorder/man/Recording.html)
    to render the GIF.

``` r

gg_record(
  dir    = file.path(tempdir(), "viz-frames"),
  device = "png",
  width  = 1000,
  height = 600,
  units  = "px",
  dpi    = 96,
  bg     = "white"
)

# ... loop printing one ggplot per frame ...

gg_playback(
  name                 = "viz-git.gif",
  first_image_duration = 1,
  last_image_duration  = 4,
  frame_duration       = 0.5,
  image_resize         = 1000
)
```

The three recipes below all reuse this skeleton and only differ in
*what* is plotted on each frame.

## Recipe 1: cumulative commits, sliding the end date

[`cumulative_line_plot()`](https://mjfrigaard.github.io/ghreadme/reference/cumulative_line_plot.md)
already shows growth over time, but stepping the `date_end` forward one
month at a time makes that growth feel kinetic — lines appear, lengthen,
and overtake one another as your repos accumulate commits.

``` r

date_seq <- seq(
  from = as.Date("2023-01-01"),
  to   = max(commits$date),
  by   = "1 month"
)

gg_record(
  dir    = file.path(tempdir(), "cumulative-frames"),
  device = "png",
  width  = 1000,
  height = 600,
  units  = "px",
  dpi    = 96,
  bg     = "white"
)

for (d in date_seq) {
  p <- cumulative_line_plot(
    commits,
    date_begin = "2023-01-01",
    date_end   = as.Date(d, origin = "1970-01-01"),
    top_n      = 8
  )
  print(p)
}

gg_playback(
  name                 = "cumulative.gif",
  first_image_duration = 1,
  last_image_duration  = 4,
  frame_duration       = 0.4,
  image_resize         = 1000
)
```

## Recipe 2: calendar heatmap, year by year

[`calendar_heatmap_plot()`](https://mjfrigaard.github.io/ghreadme/reference/calendar_heatmap_plot.md)
is a strong fit for a slow reveal: each frame adds one more year of
history, so the GIF builds toward the present. Because the plot’s
`date_begin` argument is honoured during filtering, all you need to do
is bump `date_end` to the end of the next year.

``` r

years <- sort(unique(commits$year))

gg_record(
  dir    = file.path(tempdir(), "calendar-frames"),
  device = "png",
  width  = 1100,
  height = 700,
  units  = "px",
  dpi    = 96,
  bg     = "white"
)

for (yr in years) {
  p <- calendar_heatmap_plot(
    commits,
    date_begin = paste0(min(years), "-01-01"),
    date_end   = paste0(yr, "-12-31"),
    title      = paste("Through", yr)
  )
  print(p)
}

gg_playback(
  name                 = "calendar.gif",
  first_image_duration = 1,
  last_image_duration  = 4,
  frame_duration       = 1.2,
  image_resize         = 1100
)
```

## Recipe 3: punchcard carousel across repos

The third pattern cycles through repositories instead of through time —
[`punchcard_plot()`](https://mjfrigaard.github.io/ghreadme/reference/punchcard_plot.md)
is rendered once per repo, so the GIF feels like flipping through a deck
of cards.

``` r

top_repos <- commits |>
  dplyr::count(repo, sort = TRUE) |>
  dplyr::slice_head(n = 6) |>
  dplyr::pull(repo)

gg_record(
  dir    = file.path(tempdir(), "punchcard-frames"),
  device = "png",
  width  = 1000,
  height = 500,
  units  = "px",
  dpi    = 96,
  bg     = "white"
)

for (r in top_repos) {
  p <- punchcard_plot(commits, repo = r, title = r)
  print(p)
}

gg_playback(
  name                 = "punchcard.gif",
  first_image_duration = 1,
  last_image_duration  = 4,
  frame_duration       = 1.5,
  image_resize         = 1000
)
```

## Tips

- **Frame count vs file size.** GIFs are uncompressed across frames, so
  a monthly cadence over five years (60 frames) renders nicely; a daily
  cadence produces a multi-megabyte file. Pick a step that yields 20–80
  frames.
- **Final-frame hold.** `last_image_duration` (in seconds) gives readers
  time to absorb the end state before the GIF loops. 3–5 seconds is a
  good range.
- **Consistent axes.** Some plots auto-scale per frame, which makes axes
  jitter as data is added. If that bothers you, pass an explicit
  `date_begin` /`date_end` so the x-axis stays fixed across frames.
- **Spiral plots are not ggplots.**
  [`spiral_points_plot()`](https://mjfrigaard.github.io/ghreadme/reference/spiral_points_plot.md),
  [`spiral_heatmap_plot()`](https://mjfrigaard.github.io/ghreadme/reference/spiral_heatmap_plot.md),
  and
  [`spiral_horizon_plot()`](https://mjfrigaard.github.io/ghreadme/reference/spiral_horizon_plot.md)
  draw with the `grid` /`spiralize` graphics system, so
  [`camcorder::gg_record()`](https://rdrr.io/pkg/camcorder/man/Recording.html)
  won’t capture them. To animate those, render each frame to a numbered
  PNG with [`grDevices::png()`](https://rdrr.io/r/grDevices/png.html) /
  [`dev.off()`](https://rdrr.io/r/grDevices/dev.html) and then call
  [`gifski::gifski()`](https://r-rust.r-universe.dev/gifski/reference/gifski.html)
  directly on the file list.

## Embedding in your README

Drop the rendered GIF into your profile `README.Rmd` the same way as any
image — typically right above the badge block so it plays as soon as
someone loads your profile:

    ![](cumulative.gif)

Re-knit `README.Rmd` to refresh `README.md`, then commit the GIF
alongside it.
