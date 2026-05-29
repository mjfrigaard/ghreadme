# Pulling stars, issues, and pull requests

[`collect_git_commits()`](https://mjfrigaard.github.io/ghreadme/reference/collect_git_commits.md)
historically returned one tibble: commit metadata across the user’s
non-fork repos. As of v0.1.0 it accepts an `include` argument that opts
in to richer GitHub-level activity data: per-repo `stars`, authored
`issues`, and authored `prs`. This vignette walks through each new type,
what the schema looks like, and a few patterns for turning the data into
something you can embed in your profile README.

## Authentication

Every call is routed through
[`gh::gh()`](https://gh.r-lib.org/reference/gh.html), which reads a
personal access token from the `GITHUB_PAT` environment variable.
Without a token you are held to 60 requests per hour, which is not
enough for any non-trivial account; with a fine-grained PAT (read-only
`Metadata`, `Contents`, and `Issues`) the limit is 5,000 requests per
hour. The `/search/issues` endpoint used by
`include = c("issues", "prs")` has its own per-query ceiling of 1,000
results.

``` r

# In your .Renviron or a session:
# GITHUB_PAT=ghp_xxx
Sys.getenv("GITHUB_PAT") != ""
```

## Commits (the default)

Calling the function with no `include` argument preserves the original
behavior: a single tibble of commits, with derived `date`, `hour`,
`weekday`, and `year` columns ready for the plotting helpers.

``` r

library(ghreadme)

commits <- collect_git_commits(
  user   = "your-username",
  emails = c("you@example.com", "you@work.example.com")
)

head(commits)
```

## Stars received on your repos

`include = "stars"` returns one row per non-fork repo you own, with the
star, fork, and watcher counts plus the language and description. Rows
are sorted in descending order of stars.

``` r

stats <- collect_git_commits(
  user    = "your-username",
  include = "stars"
)
stats$stars
```

A common use is a “top-starred repos” bar chart in the README:

``` r

library(ggplot2)

stats$stars |>
  head(10) |>
  ggplot(aes(
    x = stargazers_count,
    y = reorder(repo, stargazers_count)
  )) +
  geom_col(fill = "#1E5F8C") +
  labs(
    x = "Stars",
    y = NULL,
    title = "Top 10 repos by stars"
  ) +
  theme_minimal()
```

## Issues you’ve authored across GitHub

`include = "issues"` hits the `/search/issues` endpoint with
`author:<user> type:issue`, so it returns issues *anywhere* on GitHub
that you opened (not just on your own repos). Each row carries `repo`
(`owner/name`), `number`, `title`, `state`, `created_at`, `closed_at`,
and the issue `url`.

``` r

stats <- collect_git_commits(
  user    = "your-username",
  include = "issues"
)
stats$issues
```

A small “issues opened per year, by state” summary:

``` r

library(dplyr)

stats$issues |>
  mutate(year = as.integer(format(created_at, "%Y"))) |>
  count(year, state) |>
  tidyr::pivot_wider(names_from = state, values_from = n, values_fill = 0)
```

## Pull requests you’ve authored

`include = "prs"` shares the schema of `issues` but filters the search
with `type:pr`. The same `state` field (`open` or `closed`) applies.

``` r

stats <- collect_git_commits(
  user    = "your-username",
  include = "prs"
)
stats$prs
```

A “merge rate” approximation, treating `closed` PRs as merged (the
search endpoint does not distinguish merged from closed-without-merging;
pull the detail endpoint per PR if you need that):

``` r

stats$prs |>
  count(state) |>
  mutate(pct = n / sum(n))
```

## Pulling everything in one call

Passing multiple values to `include` switches the return type from a
single tibble to a named list, with one element per requested type.

``` r

stats <- collect_git_commits(
  user    = "your-username",
  emails  = "you@example.com",
  include = c("commits", "stars", "issues", "prs")
)

names(stats)
#> [1] "commits" "stars" "issues" "prs"
```

A one-shot “profile stats” summary suitable for the top of a profile
README:

``` r

tibble::tibble(
  metric = c("Public repos", "Total stars", "Commits", "Issues opened",
             "Pull requests opened"),
  value  = c(
    nrow(stats$stars),
    sum(stats$stars$stargazers_count),
    nrow(stats$commits),
    nrow(stats$issues),
    nrow(stats$prs)
  )
) |>
  knitr::kable()
```

## Date bounds

`since` and `until` apply to all four types: for commits they are passed
to the API directly; for issues and pull requests they are translated to
`created:>=YYYY-MM-DD` / `created:<=YYYY-MM-DD` qualifiers on the search
query.

``` r

this_year <- collect_git_commits(
  user    = "your-username",
  emails  = "you@example.com",
  since   = "2025-01-01",
  include = c("commits", "issues", "prs")
)
```

## Embedding in your README

The simplest pattern is to call
[`collect_git_commits()`](https://mjfrigaard.github.io/ghreadme/reference/collect_git_commits.md)
once at the top of `README.Rmd` (with `include` set to whatever you want
to show), then drop small tables or plots into the body. Because the
call hits the API every knit, pair it with the scheduled rebuild from
[`use_profile_readme_action()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme_action.md)
so the numbers stay fresh.

``` r

# In README.Rmd:
stats <- collect_git_commits(
  user    = "your-username",
  emails  = "you@example.com",
  include = c("commits", "stars", "prs")
)

# Then drop a chart or table into the README body
```

## Related vignettes

- [`vignette("ghreadme")`](https://mjfrigaard.github.io/ghreadme/articles/ghreadme.md);
  end-to-end scaffolding of a profile `README.Rmd` and the GitHub Action
  that re-knits it on a schedule.
- [`vignette("viz-git-gif")`](https://mjfrigaard.github.io/ghreadme/articles/viz-git-gif.md);
  turning the commit visualization functions
  ([`calendar_heatmap_plot()`](https://mjfrigaard.github.io/ghreadme/reference/calendar_heatmap_plot.md),
  [`punchcard_plot()`](https://mjfrigaard.github.io/ghreadme/reference/punchcard_plot.md),
  [`cumulative_line_plot()`](https://mjfrigaard.github.io/ghreadme/reference/cumulative_line_plot.md))
  into animated GIFs.
