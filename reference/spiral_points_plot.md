# Spiral plot of daily commit counts (points)

Spiral plot of daily commit counts (points)

## Usage

``` r
spiral_points_plot(
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

  Optional repo name (or vector of names). `NULL` aggregates across all
  repos in `commits`.

- date_begin, date_end:

  Optional Date bounds.

- title:

  Legend/plot title. Defaults to repo name(s) or "All repos".

## Value

Invisibly returns the per-day commit summary used for plotting.
