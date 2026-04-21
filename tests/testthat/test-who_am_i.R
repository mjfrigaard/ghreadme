test_that("who_am_i runs without error", {
  local_mocked_bindings(Sys.sleep = function(...) invisible(NULL), .package = "ghreadme")
  expect_no_error(
    who_am_i(
      name   = "Martin",
      likes  = "#rstats",
      learn  = "testing",
      work   = "packages",
      collab = "open source"
    )
  )
})

test_that("who_am_i runs with connect = FALSE without error", {
  local_mocked_bindings(Sys.sleep = function(...) invisible(NULL), .package = "ghreadme")
  expect_no_error(
    who_am_i(
      name    = "Martin",
      likes   = "#rstats",
      learn   = "testing",
      work    = "packages",
      collab  = "open source",
      connect = FALSE
    )
  )
})

test_that("who_am_i connect = TRUE prints the connect message", {
  local_mocked_bindings(Sys.sleep = function(...) invisible(NULL), .package = "ghreadme")
  out <- capture.output(
    who_am_i("Martin", "#rstats", "testing", "packages", "open source", connect = TRUE),
    type = "message"
  )
  expect_true(any(grepl("connect", out, ignore.case = TRUE)))
})

test_that("who_am_i connect = FALSE omits the connect message", {
  local_mocked_bindings(Sys.sleep = function(...) invisible(NULL), .package = "ghreadme")
  out <- capture.output(
    who_am_i("Martin", "#rstats", "testing", "packages", "open source", connect = FALSE),
    type = "message"
  )
  expect_false(any(grepl("connect", out, ignore.case = TRUE)))
})
