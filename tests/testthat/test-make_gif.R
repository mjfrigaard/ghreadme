# Helper: write n minimal PNG files into a fresh temp subdirectory
make_test_png_dir <- function(n, width = 400, height = 400) {
  dir <- file.path(
    tempdir(),
    paste0("make-gif-test-", as.integer(Sys.time()), "-", sample(9999L, 1L))
  )
  dir.create(dir, showWarnings = FALSE)
  for (i in seq_len(n)) {
    grDevices::png(
      filename = file.path(dir, sprintf("%04d.png", i)),
      width    = width,
      height   = height
    )
    graphics::par(mar = rep(0, 4))
    graphics::plot.new()
    grDevices::dev.off()
  }
  dir
}

test_that("make_gif errors when frame_dir contains no PNGs", {
  empty_dir <- file.path(tempdir(), "make-gif-empty")
  dir.create(empty_dir, showWarnings = FALSE)

  expect_error(
    make_gif(empty_dir, tempfile(fileext = ".gif"), width = 100, height = 100),
    "No PNG frames found"
  )
})

test_that("make_gif creates a GIF file from multiple PNG frames", {
  skip_if_not_installed("gifski")

  frame_dir <- make_test_png_dir(n = 3)
  output    <- tempfile(fileext = ".gif")

  make_gif(frame_dir, output, width = 400, height = 400)

  expect_true(file.exists(output))
  expect_gt(file.size(output), 0L)
})

test_that("make_gif returns the output path invisibly", {
  skip_if_not_installed("gifski")

  frame_dir <- make_test_png_dir(n = 2)
  output    <- tempfile(fileext = ".gif")

  result <- make_gif(frame_dir, output, width = 400, height = 400)

  expect_equal(result, output)
  # Confirm the value is returned invisibly (withVisible detects this)
  expect_false(withVisible(make_gif(frame_dir, output, width = 400, height = 400))$visible)
})

test_that("make_gif handles a single PNG frame", {
  skip_if_not_installed("gifski")

  frame_dir <- make_test_png_dir(n = 1)
  output    <- tempfile(fileext = ".gif")

  expect_no_error(
    make_gif(frame_dir, output, width = 400, height = 400)
  )
  expect_true(file.exists(output))
})
