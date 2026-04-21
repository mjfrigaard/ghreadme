test_that("gh_badges returns a character string for a single badge", {
  result <- gh_badges(username = "mjfrigaard", badge = "stats", theme = "dark")
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("gh_badges returns one element per badge when multiple are given", {
  result <- gh_badges(username = "mjfrigaard", badge = c("details", "stats"), theme = "dark")
  expect_length(result, 2)
})

test_that("gh_badges embeds the username in the URL", {
  result <- gh_badges(username = "testuser", badge = "stats", theme = "default")
  expect_match(result, "testuser")
})

test_that("gh_badges maps badge names to vercel card paths", {
  expect_match(gh_badges("u", "details", "default"),     "profile-details")
  expect_match(gh_badges("u", "commit_lang", "default"), "most-commit-language")
  expect_match(gh_badges("u", "ptime", "default"),       "productive-time")
  expect_match(gh_badges("u", "repo_lang", "default"),   "repos-per-language")
  expect_match(gh_badges("u", "stats", "default"),       "cards/stats")
})

test_that("gh_badges maps theme names to vercel theme strings", {
  expect_match(gh_badges("u", "stats", "dark"),    "github_dark")
  expect_match(gh_badges("u", "stats", "light"),   "github_light")
  expect_match(gh_badges("u", "stats", "default"), "theme=default")
})

test_that("gh_badges output is valid markdown image syntax", {
  result <- gh_badges(username = "mjfrigaard", badge = "stats", theme = "dark")
  expect_match(result, "^!\\[\\]\\(http")
})
