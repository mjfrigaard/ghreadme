fake_repos <- list(
  list(name = "repo-a", fork = FALSE,
       stargazers_count = 12L, forks_count = 3L, watchers_count = 12L,
       language = "R", description = "first",
       created_at = "2023-01-01T00:00:00Z",
       updated_at = "2024-06-01T00:00:00Z"),
  list(name = "repo-b", fork = FALSE,
       stargazers_count = 1L, forks_count = 0L, watchers_count = 1L,
       language = "R", description = "second",
       created_at = "2024-01-01T00:00:00Z",
       updated_at = "2024-06-01T00:00:00Z"),
  list(name = "repo-fork", fork = TRUE,
       stargazers_count = 0L, forks_count = 0L, watchers_count = 0L,
       language = NULL, description = NULL,
       created_at = "2024-02-01T00:00:00Z",
       updated_at = "2024-02-01T00:00:00Z")
)

fake_issues_response <- list(
  total_count = 2,
  items = list(
    list(
      repository_url = "https://api.github.com/repos/upstream/proj",
      number = 7L, title = "bug: thing broken", state = "closed",
      created_at = "2024-02-01T00:00:00Z",
      closed_at  = "2024-02-15T00:00:00Z",
      html_url   = "https://github.com/upstream/proj/issues/7"
    ),
    list(
      repository_url = "https://api.github.com/repos/upstream/proj",
      number = 9L, title = "feat: add knob", state = "open",
      created_at = "2024-05-01T00:00:00Z",
      closed_at  = NULL,
      html_url   = "https://github.com/upstream/proj/issues/9"
    )
  )
)

fake_prs_response <- list(
  total_count = 1,
  items = list(
    list(
      repository_url = "https://api.github.com/repos/upstream/proj",
      number = 42L, title = "fix: typo", state = "closed",
      created_at = "2024-03-10T00:00:00Z",
      closed_at  = "2024-03-11T00:00:00Z",
      html_url   = "https://github.com/upstream/proj/pull/42"
    )
  )
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
  if (grepl("/search/issues", endpoint)) {
    args <- list(...)
    q <- args$q %||% ""
    if (grepl("type:pr", q, fixed = TRUE)) return(fake_prs_response)
    return(fake_issues_response)
  }
  list()
}

`%||%` <- function(x, y) if (is.null(x)) y else x

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

test_that("collect_git_commits includes forks when include_forks = TRUE", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard", include_forks = TRUE)
  expect_true("repo-fork" %in% result$repo)
})

test_that("include = 'commits' (default) returns a bare tibble", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard", include = "commits")
  expect_s3_class(result, "tbl_df")
  expect_false(is.list(result) && !inherits(result, "data.frame"))
})

test_that("include with multiple types returns a named list of tibbles", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(
    user    = "mjfrigaard",
    include = c("commits", "stars", "issues", "prs")
  )
  expect_type(result, "list")
  expect_setequal(names(result), c("commits", "stars", "issues", "prs"))
  expect_s3_class(result$commits, "tbl_df")
  expect_s3_class(result$stars,   "tbl_df")
  expect_s3_class(result$issues,  "tbl_df")
  expect_s3_class(result$prs,     "tbl_df")
})

test_that("include = 'stars' yields per-repo star counts sorted desc", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard", include = "stars")
  expect_true(all(c("repo", "stargazers_count", "forks_count",
                    "language", "description") %in% names(result$stars)))
  expect_equal(result$stars$repo, c("repo-a", "repo-b"))
  expect_equal(result$stars$stargazers_count, c(12L, 1L))
})

test_that("include = 'issues' parses search results", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard", include = "issues")
  expect_equal(result$issues$repo, c("upstream/proj", "upstream/proj"))
  expect_equal(result$issues$state, c("open", "closed"))    # sorted desc by created_at
  expect_true(is.na(result$issues$closed_at[result$issues$state == "open"]))
})

test_that("include = 'prs' uses the type:pr query branch", {
  skip_if_not_installed("gh")
  local_mocked_bindings(gh = fake_gh, .package = "gh")

  result <- collect_git_commits(user = "mjfrigaard", include = "prs")
  expect_equal(nrow(result$prs), 1)
  expect_equal(result$prs$number, 42L)
  expect_equal(result$prs$state, "closed")
})

test_that("include rejects unknown values", {
  skip_if_not_installed("gh")
  expect_error(
    collect_git_commits(user = "mjfrigaard", include = "nonsense"),
    "should be one of"
  )
})
