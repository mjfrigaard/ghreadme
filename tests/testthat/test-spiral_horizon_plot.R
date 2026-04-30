test_that("spiral_horizon_plot runs and returns per-day summary", {
  skip_if_not_installed("spiralize")
  skip_if_not_installed("ComplexHeatmap")
  skip_if_not_installed("lubridate")

  df <- with_null_graphics(spiral_horizon_plot(make_test_commits()))
  expect_s3_class(df, "tbl_df")
  expect_named(df, c("date", "commits"))
})

test_that("spiral_horizon_plot totals match input row count", {
  skip_if_not_installed("spiralize")
  skip_if_not_installed("ComplexHeatmap")

  commits <- make_test_commits()
  df <- with_null_graphics(spiral_horizon_plot(commits))
  expect_equal(sum(df$commits), nrow(commits))
})

test_that("spiral_horizon_plot errors when filters leave no commits", {
  skip_if_not_installed("spiralize")

  expect_error(
    with_null_graphics(spiral_horizon_plot(make_test_commits(), repo = "nope")),
    "No commits after filtering"
  )
})
