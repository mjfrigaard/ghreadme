# Create a GIF of who_am_i() console output

Records each message from
[`who_am_i()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i.md)
as a ggplot frame using `camcorder`, then renders the frames to a gif
with `gifski`.

## Usage

``` r
who_am_i_gif(
  name,
  likes,
  learn,
  work,
  collab,
  connect = TRUE,
  output = "intro.gif",
  width = 800,
  height = 400,
  frame_duration = 1.5
)
```

## Arguments

- name:

  Your name

- likes:

  Your likes

- learn:

  What you're learning

- work:

  What you're currently working on

- collab:

  What you'd like to collaborate on

- connect:

  logical, include the connect message (default `TRUE`)

- output:

  path for the output gif (default `"intro.gif"`)

- width:

  gif width in pixels (default `800`)

- height:

  gif height in pixels (default `400`)

- frame_duration:

  seconds each frame is shown (default `1.5`)

## Value

invisibly returns `output` path

## Examples

``` r
if (FALSE) { # \dontrun{
who_am_i_gif(
  name   = "Martin",
  likes  = "#rstats and data visualization.",
  learn  = "shiny app development, JavaScript, and Bayesian statistics.",
  work   = "R package development tools.",
  collab = "#rstats packages for data science.",
  output = "intro.gif"
)
} # }
```
