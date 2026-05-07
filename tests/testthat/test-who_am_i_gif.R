test_that("who_am_i_gif creates a GIF at the specified output path", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("gifski")

  output <- tempfile(fileext = ".gif")
  who_am_i_gif(
    name   = "Test",
    likes  = "testing",
    learn  = "R",
    work   = "packages",
    collab = "open source",
    output = output
  )
  expect_true(file.exists(output))
  expect_gt(file.size(output), 0L)
})

test_that("who_am_i_gif returns the output path invisibly", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("gifski")

  output <- tempfile(fileext = ".gif")
  result <- who_am_i_gif(
    name = "Test", likes = "testing", learn = "R",
    work = "packages", collab = "open source",
    output = output
  )
  expect_equal(result, output)
  expect_false(
    withVisible(who_am_i_gif(
      name = "Test", likes = "testing", learn = "R",
      work = "packages", collab = "open source",
      output = output
    ))$visible
  )
})

test_that("who_am_i_gif connect = TRUE writes 6 PNG frames", {
  skip_if_not_installed("ggplot2")

  captured_dir <- NULL
  local_mocked_bindings(
    make_gif = function(frame_dir, output, ...) {
      captured_dir <<- frame_dir
      invisible(output)
    },
    .package = "ghreadme"
  )

  who_am_i_gif(
    name = "Test", likes = "testing", learn = "R",
    work = "packages", collab = "open source",
    connect = TRUE,
    output  = tempfile(fileext = ".gif")
  )

  n_frames <- length(list.files(captured_dir, pattern = "\\.png$"))
  expect_equal(n_frames, 6L)
})

test_that("who_am_i_gif connect = FALSE writes 5 PNG frames", {
  skip_if_not_installed("ggplot2")

  captured_dir <- NULL
  local_mocked_bindings(
    make_gif = function(frame_dir, output, ...) {
      captured_dir <<- frame_dir
      invisible(output)
    },
    .package = "ghreadme"
  )

  who_am_i_gif(
    name = "Test", likes = "testing", learn = "R",
    work = "packages", collab = "open source",
    connect = FALSE,
    output  = tempfile(fileext = ".gif")
  )

  n_frames <- length(list.files(captured_dir, pattern = "\\.png$"))
  expect_equal(n_frames, 5L)
})
