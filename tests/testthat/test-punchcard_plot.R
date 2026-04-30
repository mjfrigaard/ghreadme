test_that("punchcard_plot returns a ggplot", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyr")

  p <- punchcard_plot(make_test_commits())
  expect_s3_class(p, "ggplot")
})

test_that("punchcard_plot pads to a full 7x24 grid", {
  skip_if_not_installed("ggplot2")

  p <- punchcard_plot(make_test_commits())
  expect_equal(nrow(p$data), 7 * 24)
})

test_that("punchcard_plot hours span 0..23", {
  skip_if_not_installed("ggplot2")

  p <- punchcard_plot(make_test_commits())
  expect_setequal(unique(p$data$hour), 0:23)
})

test_that("punchcard_plot errors when filters leave no commits", {
  skip_if_not_installed("ggplot2")

  expect_error(
    punchcard_plot(make_test_commits(), repo = "nope"),
    "No commits after filtering"
  )
})

test_that("punchcard_plot total commits equals input row count", {
  skip_if_not_installed("ggplot2")

  commits <- make_test_commits()
  p <- punchcard_plot(commits)
  expect_equal(sum(p$data$commits), nrow(commits))
})
