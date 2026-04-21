test_that("so_rep returns a character string", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_type(result, "character")
})

test_that("so_rep embeds username and user_id in the output", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_match(result, "martin-frigaard")
  expect_match(result, "4926446")
})

test_that("so_rep links to the correct Stack Overflow profile URL", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_match(result, "stackoverflow.com/users/4926446/martin-frigaard")
})

test_that("so_rep badge image points to stackoverflow-badge.vercel.app", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_match(result, "stackoverflow-badge.vercel.app/\\?userID=4926446")
})

test_that("so_rep output contains an anchor tag with target _blank", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_match(result, "<a href=")
  expect_match(result, "target='_blank'")
})

test_that("so_rep output contains an img tag with StackOverflow alt text", {
  result <- so_rep(username = "martin-frigaard", user_id = "4926446")
  expect_match(result, "<img alt='StackOverflow'")
})
