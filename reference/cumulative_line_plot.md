# Cumulative commits over time, one line per repo

Cumulative commits over time, one line per repo

## Usage

``` r
cumulative_line_plot(
  commits,
  repo = NULL,
  date_begin = NULL,
  date_end = NULL,
  top_n = 10,
  show_other = TRUE,
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

- top_n:

  Keep this many most-active repos as their own lines; only applied when
  `repo` is `NULL`.

- show_other:

  If `TRUE`, roll the non-top repos into an "Other" line.

- title:

  Plot title.

## Value

A ggplot2 object.
