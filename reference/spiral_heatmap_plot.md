# Spiral heatmap of daily commit counts

Spiral heatmap of daily commit counts

## Usage

``` r
spiral_heatmap_plot(
  commits,
  repo = NULL,
  date_begin = NULL,
  date_end = NULL,
  title = NULL
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

  Legend title. Defaults to repo name(s) or "All repos".

## Value

Invisibly returns the per-day commit summary.
