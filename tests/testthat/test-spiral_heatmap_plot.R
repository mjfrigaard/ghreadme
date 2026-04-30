test_that("spiral_heatmap_plot runs and returns per-day summary", {
  skip_if_not_installed("spiralize")
  skip_if_not_installed("ComplexHeatmap")
  skip_if_not_installed("circlize")
  skip_if_not_installed("RColorBrewer")
  skip_if_not_installed("lubridate")

  df <- with_null_graphics(spiral_heatmap_plot(make_test_commits()))
  expect_s3_class(df, "tbl_df")
  expect_named(df, c("date", "commits"))
})

test_that("spiral_heatmap_plot respects date bounds", {
  skip_if_not_installed("spiralize")
  skip_if_not_installed("ComplexHeatmap")

  df <- with_null_graphics(
    spiral_heatmap_plot(
      make_test_commits(),
      date_begin = "2024-01-01",
      date_end   = "2024-06-30"
    )
  )
  expect_true(all(df$date >= as.Date("2024-01-01")))
  expect_true(all(df$date <= as.Date("2024-06-30")))
})

test_that("spiral_heatmap_plot errors when filters leave no commits", {
  skip_if_not_installed("spiralize")

  expect_error(
    with_null_graphics(spiral_heatmap_plot(make_test_commits(), repo = "nope")),
    "No commits after filtering"
  )
})
