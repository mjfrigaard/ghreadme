test_that("calendar_heatmap_plot returns a ggplot", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("dplyr")

  p <- calendar_heatmap_plot(make_test_commits())
  expect_s3_class(p, "ggplot")
})

test_that("calendar_heatmap_plot errors when filters leave no commits", {
  skip_if_not_installed("ggplot2")

  expect_error(
    calendar_heatmap_plot(make_test_commits(), repo = "nope"),
    "No commits after filtering"
  )
})

test_that("calendar_heatmap_plot accepts multiple repos", {
  skip_if_not_installed("ggplot2")

  p <- calendar_heatmap_plot(
    make_test_commits(),
    repo = c("repo-a", "repo-b")
  )
  expect_s3_class(p, "ggplot")
})

test_that("calendar_heatmap_plot respects date bounds", {
  skip_if_not_installed("ggplot2")

  p <- calendar_heatmap_plot(
    make_test_commits(),
    date_begin = "2024-01-01",
    date_end   = "2024-06-30"
  )
  expect_s3_class(p, "ggplot")
  expect_true(all(p$data$date >= as.Date("2024-01-01")))
  expect_true(all(p$data$date <= as.Date("2024-06-30")))
})

test_that("calendar_heatmap_plot validates week_start", {
  skip_if_not_installed("ggplot2")

  expect_error(
    calendar_heatmap_plot(make_test_commits(), week_start = "Tuesday")
  )
})

test_that("calendar_heatmap_plot facets by year", {
  skip_if_not_installed("ggplot2")

  p <- calendar_heatmap_plot(make_test_commits())
  expect_s3_class(p$facet, "FacetWrap")
})
