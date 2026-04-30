# Punchcard plot: commits by weekday and hour of day

Punchcard plot: commits by weekday and hour of day

## Usage

``` r
punchcard_plot(
  commits,
  repo = NULL,
  date_begin = NULL,
  date_end = NULL,
  title = NULL,
  point_color = "#1f6feb"
)
```

## Arguments

- commits:

  Tidy data frame from
  [`collect_git_commits()`](https://mjfrigaard.github.io/ghreadme/reference/collect_git_commits.md).

- repo:

  Optional repo name (or vector). `NULL` aggregates all repos.

- date_begin, date_end:

  Optional Date bounds.

- title:

  Plot title. Defaults to repo name(s) or "All repos".

- point_color:

  Fill color for the circles.

## Value

A ggplot2 object.
