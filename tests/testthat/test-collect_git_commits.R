fake_repos <- list(
  list(name = "repo-a", fork = FALSE),
  list(name = "repo-b", fork = FALSE),
  list(name = "repo-fork", fork = TRUE)
)

fake_commits <- list(
  list(
    sha = "abc123",
    commit = list(
      author  = list(date = "2024-03-15T10:30:00Z",
                     name = "Test", email = "test@example.com"),
      message = "first"
    )
  ),
  list(
    sha = "def456",
    commit = list(
      author  = list(date = "2024-06-20T14:45:00Z",
                     name = "Other", email = "other@example.com"),
      message = "second"
    )
  )
)

fake_gh <- function(endpoint, ...) {
  if (grepl("/users/", endpoint)) return(fake_repos)
  if (grepl("/commits", endpoint)) return(fake_commits)
  list()
}

test_that("collect_git_commits returns a tibble with derived columns", {
  skip_if_not_installed("gh")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tibble")
  skip_if_not_installed("purrr")

  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard")

  expect_s3_class(result, "tbl_df")
  expect_true(all(c("repo", "sha", "timestamp", "local_ts",
                    "date", "hour", "weekday", "year") %in% names(result)))
})

test_that("collect_git_commits drops forks by default", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard")
  expect_false("repo-fork" %in% result$repo)
  expect_setequal(unique(result$repo), c("repo-a", "repo-b"))
})

test_that("collect_git_commits filters by email (case-insensitive)", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(
    user   = "mjfrigaard",
    emails = "TEST@example.com"
  )
  expect_true(all(tolower(result$author_email) == "test@example.com"))
  expect_false("other@example.com" %in% result$author_email)
})

test_that("collect_git_commits warns when the API returns no commits", {
  skip_if_not_installed("gh")
  empty_gh <- function(endpoint, ...) {
    if (grepl("/users/", endpoint)) return(fake_repos)
    list()
  }
  local_mocked_bindings(gh = empty_gh, .package = "gh")

  expect_warning(
    collect_git_commits(user = "mjfrigaard"),
    "No commits returned"
  )
})

test_that("collect_git_commits returns results sorted by timestamp", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard")
  expect_equal(result$timestamp, sort(result$timestamp))
})
