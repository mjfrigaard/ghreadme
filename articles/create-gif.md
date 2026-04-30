# Create a GIF for your GitHub README

GitHub profile READMEs support animated GIFs, making it easy to show a
short introduction that plays automatically when someone visits your
profile. This vignette walks through using
[`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
to generate that GIF and embed it in your README.

## Prerequisites

[`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
requires three packages that are not installed with `ghreadme` by
default:

``` r

install.packages(c("camcorder", "gifski", "ggplot2"))
```

[`camcorder`](https://thebioengineer.r-universe.dev/camcorder) records
each ggplot frame to a temporary PNG, and
[`gifski`](https://github.com/r-rust/gifski) stitches those PNGs into
the final GIF. `ggplot2` renders the text as plot frames.

## Create the GIF

Call
[`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
with the same information you would pass to
[`who_am_i()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i.md).
The `output` argument controls where the GIF is saved — set it to a path
inside your profile repository:

``` r

library(ghreadme)

who_am_i_gif(
  name   = "Martin",
  likes  = "#rstats and data visualization.",
  learn  = "Shiny app development, Python, and Linux",
  work   = "R package development tools.",
  collab = "#rstats packages for data science.",
  output = "intro.gif"
)
```

The function prints each message as a cumulative frame on a dark
background, mimicking console output. After the last frame there is a
4-second hold before the GIF loops, giving readers time to read the
final line.

### Adjust timing and size

| Argument         | Default | Effect                               |
|------------------|---------|--------------------------------------|
| `frame_duration` | `1.5`   | Seconds each new-line frame is shown |
| `width`          | `800`   | GIF width in pixels                  |
| `height`         | `400`   | GIF height in pixels                 |

``` r

who_am_i_gif(
  name           = "Martin",
  likes          = "#rstats and data visualization.",
  learn          = "Shiny app development, Python, and Linux",
  work           = "R package development tools.",
  collab         = "#rstats packages for data science.",
  output         = "intro.gif",
  frame_duration = 2,
  width          = 900,
  height         = 450
)
```

### Omit the connect message

Set `connect = FALSE` to drop the final *“Want to connect?”* line:

``` r

who_am_i_gif(
  name    = "Martin",
  likes   = "#rstats and data visualization.",
  learn   = "Shiny app development, Python, and Linux",
  work    = "R package development tools.",
  collab  = "#rstats packages for data science.",
  connect = FALSE,
  output  = "intro.gif"
)
```

## Embed the GIF in your README

In your profile repository, reference the GIF at the top of `README.Rmd`
(before the badge links) so it plays when visitors land on your profile:

    ---
    title: "Hi there 👋"
    output: github_document
    ---



    ![](intro.gif)

Knit `README.Rmd` to regenerate `README.md`, then commit both files:

``` bash
git add README.Rmd README.md intro.gif
git commit -m "update profile README"
git push
```

Your profile page will display the animated introduction automatically.

## Full workflow

``` r

library(ghreadme)

# 1. Generate the GIF into your profile repo
who_am_i_gif(
  name   = "Martin",
  likes   = "#rstats and data visualization.",
  learn   = "Shiny app development, Python, and Linux",
  work    = "R package development tools.",
  collab = "#rstats packages for data science.",
  output = "path/to/mjfrigaard/intro.gif"
)

# 2. Generate badge markdown for the README body
gh_badges(
  username = "mjfrigaard",
  badge    = c("details", "commit_lang", "stats"),
  theme    = "dark"
)

# 3. Generate Stack Overflow badge HTML
so_rep(username = "martin-frigaard", user_id = "4926446")
```
