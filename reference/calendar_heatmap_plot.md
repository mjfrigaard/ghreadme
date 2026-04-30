# GitHub-style calendar heatmap of daily commit counts

GitHub-style calendar heatmap of daily commit counts

## Usage

``` r
calendar_heatmap_plot(
  commits,
  repo = NULL,
  date_begin = NULL,
  date_end = NULL,
  title = NULL,
  week_start = c("Sunday", "Monday"),
  low = "#ebedf0",
  high = "#216e39"
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

- week_start:

  "Sunday" (GitHub default) or "Monday" (ISO).

- low, high:

  Hex colors for the fill gradient endpoints.

## Value

A ggplot2 object.
