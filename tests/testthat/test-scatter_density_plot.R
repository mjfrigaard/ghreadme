test_that("scatter_density_plot returns a ggplot by default", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("scales")

  p <- scatter_density_plot(make_test_commits())
  expect_s3_class(p, "ggplot")
})

test_that("scatter_density_plot rejects identical x and y", {
  skip_if_not_installed("ggplot2")

  expect_error(
    scatter_density_plot(make_test_commits(), x = "date", y = "date"),
    "must differ"
  )
})

test_that("scatter_density_plot rejects unsupported axis names", {
  skip_if_not_installed("ggplot2")

  expect_error(
    scatter_density_plot(make_test_commits(), x = "sha", y = "date"),
    "must each be one of"
  )
})

test_that("scatter_density_plot caps repos to top_n on a repo axis", {
  skip_if_not_installed("ggplot2")

  commits <- make_test_commits(n_repos = 6, n_commits = 30)
  p <- scatter_density_plot(commits, x = "repo", y = "date", top_n = 2)
  expect_lte(length(unique(as.character(p$data$repo))), 2)
})

test_that("scatter_density_plot errors when filters leave no commits", {
  skip_if_not_installed("ggplot2")

  expect_error(
    scatter_density_plot(make_test_commits(), repo = "nope"),
    "No commits after filtering"
  )
})
