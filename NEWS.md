# ghreadme 0.1.0

- Add `use_profile_readme()` to scaffold a starter `README.Rmd` into the
  profile repo.
- Add `use_profile_readme_action()` to drop a scheduled GitHub Actions
  workflow that re-renders the profile `README.Rmd`.
- Add `vignette("ghreadme")` covering the end-to-end setup.
- `collect_git_commits()` gains an `include` argument; opt in to
  per-repo `stars`, authored `issues`, and authored `prs` alongside the
  commit metadata. Default `include = "commits"` preserves the original
  tibble return shape; any other value returns a named list of tibbles.
- Add `vignette("gh-stats")` covering the new `include` arms.
- Add `so_badge()` function (development version)



## To-do

- Import metrics from: https://github.com/lowlighter/metrics

# ghreadme 0.0.0.9000

* [x] Included code chunk example to `README.Rmd`

* [x] Added a `NEWS.md` file to track changes to the package.

