#' Collect activity from a GitHub user's account
#'
#' Pulls commit metadata and (optionally) star, issue, and pull-request data
#' for a GitHub user, via the REST API. Defaults reproduce the original
#' commits-only schema; richer profile stats are opt-in via `include`.
#'
#' @param user GitHub username (e.g., "mjfrigaard").
#' @param emails Character vector of author emails to match
#'   (case-insensitive). Applied to `commits` only.
#' @param since,until Optional date or POSIXct bounds. For commits, used as
#'   API filters; for issues and pull requests, applied to `created_at`.
#' @param include_forks Logical; include forked repos when listing the
#'   user's own repos (affects `commits` and `stars`).
#' @param include Character vector; any of `"commits"`, `"stars"`,
#'   `"issues"`, `"prs"`. Default `"commits"`.
#'
#' @return When `include = "commits"` (the default), a tibble with one row
#'   per commit and derived `date`/`hour`/`weekday`/`year` columns. For any
#'   other value of `include`, a named list of tibbles with elements named
#'   after the requested types.
#'
#'   - `commits`: `repo`, `sha`, `timestamp`, `author_name`, `author_email`,
#'     `message`, `local_ts`, `date`, `hour`, `weekday`, `year`.
#'   - `stars`: `repo`, `stargazers_count`, `forks_count`, `watchers_count`,
#'     `language`, `description`, `created_at`, `updated_at`. Rows are the
#'     user's own repos (star counts *received*, not stars given).
#'   - `issues`: `repo` (owner/name), `number`, `title`, `state`,
#'     `created_at`, `closed_at`, `url`. Issues authored by `user` across
#'     GitHub, via `/search/issues`.
#'   - `prs`: same columns as `issues`. Pull requests authored by `user`.
#'
#' @note `gh::gh()` reads `GITHUB_PAT` from the environment. Unauthenticated
#'   calls hit a 60-request/hour rate limit and will fail for users with
#'   many repos. The `/search/issues` endpoint is additionally capped at
#'   1000 results per query.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Original behavior: commits-only tibble.
#' commits <- collect_git_commits(
#'   user   = "mjfrigaard",
#'   emails = c("mjfrigaard@pm.me", "mjfrigaard@gmail.com")
#' )
#'
#' # Full profile stats as a named list of tibbles.
#' stats <- collect_git_commits(
#'   user    = "mjfrigaard",
#'   emails  = "mjfrigaard@pm.me",
#'   include = c("commits", "stars", "issues", "prs")
#' )
#' stats$stars
#' stats$prs
#' }
collect_git_commits <- function(user,
                                emails        = NULL,
                                since         = NULL,
                                until         = NULL,
                                include_forks = FALSE,
                                include       = "commits") {

  valid_types <- c("commits", "stars", "issues", "prs")
  include <- match.arg(include, choices = valid_types, several.ok = TRUE)

  for (pkg in c("gh", "dplyr", "purrr", "tibble")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the '", pkg, "' package.", call. = FALSE)
    }
  }

  iso <- function(x) {
    if (is.null(x)) return(NULL)
    format(as.POSIXct(x, tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  }

  # Only list the user's repos if we actually need them.
  repos <- NULL
  if (any(c("commits", "stars") %in% include)) {
    repos <- gh::gh("/users/{user}/repos",
                    user = user, type = "owner",
                    per_page = 100, .limit = Inf)
    if (!include_forks) {
      repos <- Filter(function(r) isFALSE(r$fork), repos)
    }
  }

  result <- list()
  if ("commits" %in% include) {
    result$commits <- .gh_collect_commits(repos, user, emails, since, until, iso)
  }
  if ("stars" %in% include) {
    result$stars <- .gh_collect_stars(repos)
  }
  if ("issues" %in% include) {
    result$issues <- .gh_collect_search(user, type = "issue", since, until)
  }
  if ("prs" %in% include) {
    result$prs <- .gh_collect_search(user, type = "pr", since, until)
  }

  # Back-compat: default call returns the bare tibble.
  if (length(include) == 1 && include == "commits") {
    return(result$commits)
  }
  result
}

# Internal: per-repo commit fetch + derived columns (the original behavior).
.gh_collect_commits <- function(repos, user, emails, since, until, iso) {
  `%||%` <- function(x, y) if (is.null(x)) y else x

  repo_names <- vapply(repos, `[[`, character(1), "name")
  message("Found ", length(repo_names), " repos for '", user, "'.")

  fetch_repo_commits <- function(repo_name) {
    author_list <- if (is.null(emails)) list(NULL) else as.list(emails)

    per_author <- purrr::map(author_list, function(a) {
      args <- list("/repos/{owner}/{repo}/commits",
                   owner = user, repo = repo_name,
                   per_page = 100, .limit = Inf)
      if (!is.null(a))     args$author <- a
      if (!is.null(since)) args$since  <- iso(since)
      if (!is.null(until)) args$until  <- iso(until)

      tryCatch(do.call(gh::gh, args), error = function(e) {
        message("  skip ", repo_name, " (", conditionMessage(e), ")")
        list()
      })
    })
    commits <- unlist(per_author, recursive = FALSE)
    if (length(commits) == 0) return(NULL)

    tibble::tibble(
      repo         = repo_name,
      sha          = vapply(commits, `[[`, character(1), "sha"),
      timestamp    = as.POSIXct(
        vapply(commits, function(x) x$commit$author$date, character(1)),
        format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
      author_name  = vapply(commits,
        function(x) x$commit$author$name  %||% NA_character_, character(1)),
      author_email = vapply(commits,
        function(x) x$commit$author$email %||% NA_character_, character(1)),
      message      = vapply(commits,
        function(x) x$commit$message      %||% NA_character_, character(1))
    )
  }

  all_commits <- purrr::map_dfr(repo_names, function(r) {
    message("Fetching ", r, " ...")
    fetch_repo_commits(r)
  })

  if (nrow(all_commits) == 0) {
    warning("No commits returned.", call. = FALSE)
    return(all_commits)
  }

  if (!is.null(emails)) {
    all_commits <- dplyr::filter(
      all_commits,
      tolower(.data$author_email) %in% tolower(emails)
    )
  }

  tz <- Sys.timezone()
  all_commits |>
    dplyr::distinct(.data$repo, .data$sha, .keep_all = TRUE) |>
    dplyr::mutate(
      local_ts = as.POSIXct(format(.data$timestamp, tz = tz), tz = tz),
      date     = as.Date(.data$local_ts),
      hour     = as.integer(format(.data$local_ts, "%H")),
      weekday  = factor(weekdays(.data$date),
                        levels = c("Monday","Tuesday","Wednesday","Thursday",
                                   "Friday","Saturday","Sunday")),
      year     = as.integer(format(.data$date, "%Y"))
    ) |>
    dplyr::arrange(.data$timestamp)
}

# Internal: stars/forks/watchers on the user's own repos.
.gh_collect_stars <- function(repos) {
  `%||%` <- function(x, y) if (is.null(x)) y else x

  if (length(repos) == 0) {
    return(tibble::tibble(
      repo             = character(),
      stargazers_count = integer(),
      forks_count      = integer(),
      watchers_count   = integer(),
      language         = character(),
      description      = character(),
      created_at       = as.POSIXct(character()),
      updated_at       = as.POSIXct(character())
    ))
  }

  intish <- function(x) as.integer(x %||% 0L)
  chrish <- function(x) x %||% NA_character_

  tibble::tibble(
    repo             = vapply(repos, `[[`, character(1), "name"),
    stargazers_count = vapply(repos, function(r) intish(r$stargazers_count), integer(1)),
    forks_count      = vapply(repos, function(r) intish(r$forks_count),      integer(1)),
    watchers_count   = vapply(repos, function(r) intish(r$watchers_count),   integer(1)),
    language         = vapply(repos, function(r) chrish(r$language),         character(1)),
    description      = vapply(repos, function(r) chrish(r$description),      character(1)),
    created_at       = as.POSIXct(
      vapply(repos, function(r) chrish(r$created_at), character(1)),
      format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    updated_at       = as.POSIXct(
      vapply(repos, function(r) chrish(r$updated_at), character(1)),
      format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  ) |>
    dplyr::arrange(dplyr::desc(.data$stargazers_count))
}

# Internal: /search/issues with author:{user} + type:{issue|pr}.
.gh_collect_search <- function(user, type = c("issue", "pr"), since, until) {
  type <- match.arg(type)
  `%||%` <- function(x, y) if (is.null(x)) y else x

  q <- paste0("author:", user, " type:", type)
  if (!is.null(since)) q <- paste0(q, " created:>=", format(as.Date(since)))
  if (!is.null(until)) q <- paste0(q, " created:<=", format(as.Date(until)))

  res <- tryCatch(
    gh::gh("/search/issues", q = q, per_page = 100, .limit = 1000),
    error = function(e) {
      message("  skip ", type, " search (", conditionMessage(e), ")")
      NULL
    }
  )
  items <- if (is.null(res)) list() else res$items %||% list()

  empty <- tibble::tibble(
    repo       = character(),
    number     = integer(),
    title      = character(),
    state      = character(),
    created_at = as.POSIXct(character()),
    closed_at  = as.POSIXct(character()),
    url        = character()
  )
  if (length(items) == 0) return(empty)

  repo_from_url <- function(u) sub(".*/repos/", "", u %||% NA_character_)

  tibble::tibble(
    repo       = vapply(items, function(x) repo_from_url(x$repository_url), character(1)),
    number     = vapply(items, function(x) as.integer(x$number), integer(1)),
    title      = vapply(items, function(x) x$title %||% NA_character_, character(1)),
    state      = vapply(items, function(x) x$state %||% NA_character_, character(1)),
    created_at = as.POSIXct(
      vapply(items, function(x) x$created_at, character(1)),
      format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    closed_at  = as.POSIXct(
      vapply(items, function(x) x$closed_at %||% NA_character_, character(1)),
      format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    url        = vapply(items, function(x) x$html_url %||% NA_character_, character(1))
  ) |>
    dplyr::arrange(dplyr::desc(.data$created_at))
}
