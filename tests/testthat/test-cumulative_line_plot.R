test_that("cumulative_line_plot returns a ggplot", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("scales")

  p <- cumulative_line_plot(make_test_commits())
  expect_s3_class(p, "ggplot")
})

test_that("cumulative_line_plot cumulative values are non-decreasing per repo", {
  skip_if_not_installed("ggplot2")

  p <- cumulative_line_plot(make_test_commits())
  per_group <- split(p$data, p$data$repo_group)
  for (g in per_group) {
    expect_equal(g$cumulative, cummax(g$cumulative))
  }
})

test_that("cumulative_line_plot buckets low-activity repos into 'Other' when top_n < repos", {
  skip_if_not_installed("ggplot2")

  commits <- make_test_commits(n_repos = 5, n_commits = 40)
  p <- cumulative_line_plot(commits, top_n = 2)
  expect_true("Other" %in% as.character(p$data$repo_group))
})

test_that("cumulative_line_plot drops 'Other' when show_other = FALSE", {
  skip_if_not_installed("ggplot2")

  commits <- make_test_commits(n_repos = 5, n_commits = 40)
  p <- cumulative_line_plot(commits, top_n = 2, show_other = FALSE)
  expect_false("Other" %in% as.character(p$data$repo_group))
})

test_that("cumulative_line_plot errors when filters leave no commits", {
  skip_if_not_installed("ggplot2")

  expect_error(
    cumulative_line_plot(make_test_commits(), repo = "nope"),
    "No commits after filtering"
  )
})
