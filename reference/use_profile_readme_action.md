# Scaffold a GitHub Action that rebuilds the profile README on a schedule

Drops `.github/workflows/profile-readme.yaml` into the repo. The
workflow installs `ghreadme` from GitHub, renders `README.Rmd` on a cron
schedule (and on manual dispatch), and commits the result if it changed.

## Usage

``` r
use_profile_readme_action(
  cron = "0 6 * * 0",
  repo = "mjfrigaard/ghreadme",
  path = ".",
  overwrite = FALSE
)
```

## Arguments

- cron:

  Cron expression for when the action runs. Default `"0 6 * * 0"`
  (Sunday 06:00 UTC).

- repo:

  GitHub `owner/name` to install `ghreadme` from. Default
  `"mjfrigaard/ghreadme"`.

- path:

  Repo root to write into. Defaults to the current directory.

- overwrite:

  Logical; replace an existing workflow file?

## Value

Invisibly returns the path to the written workflow.

## Examples

``` r
if (FALSE) { # \dontrun{
use_profile_readme_action()
use_profile_readme_action(cron = "0 6 * * 1")  # Mondays at 06:00 UTC
} # }
```
