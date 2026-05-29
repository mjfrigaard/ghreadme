# Collect activity from a GitHub user's account

Pulls commit metadata and (optionally) star, issue, and pull-request
data for a GitHub user, via the REST API. Defaults reproduce the
original commits-only schema; richer profile stats are opt-in via
`include`.

## Usage

``` r
collect_git_commits(
  user,
  emails = NULL,
  since = NULL,
  until = NULL,
  include_forks = FALSE,
  include = "commits"
)
```

## Arguments

- user:

  GitHub username (e.g., "mjfrigaard").

- emails:

  Character vector of author emails to match (case-insensitive). Applied
  to `commits` only.

- since, until:

  Optional date or POSIXct bounds. For commits, used as API filters; for
  issues and pull requests, applied to `created_at`.

- include_forks:

  Logical; include forked repos when listing the user's own repos
  (affects `commits` and `stars`).

- include:

  Character vector; any of `"commits"`, `"stars"`, `"issues"`, `"prs"`.
  Default `"commits"`.

## Value

When `include = "commits"` (the default), a tibble with one row per
commit and derived `date`/`hour`/`weekday`/`year` columns. For any other
value of `include`, a named list of tibbles with elements named after
the requested types.

- `commits`: `repo`, `sha`, `timestamp`, `author_name`, `author_email`,
  `message`, `local_ts`, `date`, `hour`, `weekday`, `year`.

- `stars`: `repo`, `stargazers_count`, `forks_count`, `watchers_count`,
  `language`, `description`, `created_at`, `updated_at`. Rows are the
  user's own repos (star counts *received*, not stars given).

- `issues`: `repo` (owner/name), `number`, `title`, `state`,
  `created_at`, `closed_at`, `url`. Issues authored by `user` across
  GitHub, via `/search/issues`.

- `prs`: same columns as `issues`. Pull requests authored by `user`.

## Note

[`gh::gh()`](https://gh.r-lib.org/reference/gh.html) reads `GITHUB_PAT`
from the environment. Unauthenticated calls hit a 60-request/hour rate
limit and will fail for users with many repos. The `/search/issues`
endpoint is additionally capped at 1000 results per query.

## Examples

``` r
if (FALSE) { # \dontrun{
# Original behavior: commits-only tibble.
commits <- collect_git_commits(
  user   = "mjfrigaard",
  emails = c("mjfrigaard@pm.me", "mjfrigaard@gmail.com")
)

# Full profile stats as a named list of tibbles.
stats <- collect_git_commits(
  user    = "mjfrigaard",
  emails  = "mjfrigaard@pm.me",
  include = c("commits", "stars", "issues", "prs")
)
stats$stars
stats$prs
} # }
```
