# Assemble a directory of PNG frames into a GIF

Collects every `.png` file in `frame_dir` (sorted alphabetically),
builds a per-frame delay vector with distinct hold times for the first
and last frames, and writes the result to a GIF via
[`gifski::gifski()`](https://r-rust.r-universe.dev/gifski/reference/gifski.html).

## Usage

``` r
make_gif(
  frame_dir,
  output,
  width,
  height,
  first_duration = 1,
  frame_duration = 0.4,
  last_duration = 4
)
```

## Arguments

- frame_dir:

  Path to a directory containing numbered `.png` frame files.

- output:

  Path for the output `.gif` file (e.g. `"animation.gif"`).

- width:

  GIF width in pixels.

- height:

  GIF height in pixels.

- first_duration:

  Seconds to hold the first frame (default `1`).

- frame_duration:

  Seconds to show each middle frame (default `0.4`).

- last_duration:

  Seconds to hold the last frame (default `4`).

## Value

Invisibly returns `output`.

## Details

The typical workflow is:

1.  Create a temporary directory.

2.  Loop over your data, saving one plot per frame with
    [`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

3.  Call `make_gif()` to assemble the frames.

## Examples

``` r
if (FALSE) { # \dontrun{
frame_dir <- file.path(tempdir(), "my-frames")
dir.create(frame_dir, showWarnings = FALSE)

for (i in 1:5) {
  p <- ggplot2::ggplot() + ggplot2::ggtitle(paste("Frame", i))
  ggplot2::ggsave(
    filename = file.path(frame_dir, sprintf("%04d.png", i)),
    plot     = p,
    width    = 800,
    height   = 400,
    units    = "px"
  )
}

make_gif(frame_dir, "animation.gif", width = 800, height = 400)
} # }
```
