# Changelog

## ghreadme 0.1.0

- Add
  [`use_profile_readme()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme.md)
  to scaffold a starter `README.Rmd` into the profile repo.
- Add
  [`use_profile_readme_action()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme_action.md)
  to drop a scheduled GitHub Actions workflow that re-renders the
  profile `README.Rmd`.
- Add
  [`vignette("ghreadme")`](https://mjfrigaard.github.io/ghreadme/articles/ghreadme.md)
  covering the end-to-end setup.
- [`collect_git_commits()`](https://mjfrigaard.github.io/ghreadme/reference/collect_git_commits.md)
  gains an `include` argument; opt in to per-repo `stars`, authored
  `issues`, and authored `prs` alongside the commit metadata. Default
  `include = "commits"` preserves the original tibble return shape; any
  other value returns a named list of tibbles.
- Add
  [`vignette("gh-stats")`](https://mjfrigaard.github.io/ghreadme/articles/gh-stats.md)
  covering the new `include` arms.
- Add `so_badge()` function (development version)

### To-do

- Import metrics from: <https://github.com/lowlighter/metrics>

## ghreadme 0.0.0.9000

Included code chunk example to `README.Rmd`

Added a `NEWS.md` file to track changes to the package.
