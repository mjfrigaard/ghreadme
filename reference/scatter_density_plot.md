# Scatter of commits across two dimensions (repo / time / date / weekday)

Scatter of commits across two dimensions (repo / time / date / weekday)

## Usage

``` r
scatter_density_plot(
  commits,
  repo = NULL,
  date_begin = NULL,
  date_end = NULL,
  x = "date",
  y = "time",
  plot_type = c("ggplot", "plotly", "density"),
  top_n = 15,
  title = NULL
)
```

## Arguments

- commits:

  Tidy data frame from
  [`collect_git_commits()`](https://mjfrigaard.github.io/ghreadme/reference/collect_git_commits.md).

- repo:

  Optional repo name (or vector). `NULL` uses all repos.

- date_begin, date_end:

  Optional Date bounds.

- x, y:

  One of "repo", "time", "date", "weekday" (must differ).

- plot_type:

  "ggplot", "plotly", or "density" (ggplot + marginal densities).

- top_n:

  When `repo` is an axis and `repo` arg is `NULL`, keep this many
  most-active repos (rest dropped to keep the axis readable).

- title:

  Plot title.

## Value

A ggplot, plotly, or ggExtra object.
