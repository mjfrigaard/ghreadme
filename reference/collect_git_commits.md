# Collect commits from all public repos of a GitHub user

Pulls every commit authored by the specified emails across all non-fork
repos owned by `user`, via the GitHub REST API.

## Usage

``` r
collect_git_commits(
  user,
  emails = NULL,
  since = NULL,
  until = NULL,
  include_forks = FALSE
)
```

## Arguments

- user:

  GitHub username (e.g., "mjfrigaard").

- emails:

  Character vector of author emails to match (case-insensitive).

- since, until:

  Optional date or POSIXct bounds.

- include_forks:

  Logical; include forked repos.

## Value

A tibble, one row per commit.
