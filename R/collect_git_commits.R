#' Collect commits from all public repos of a GitHub user
#'
#' Pulls every commit authored by the specified emails across all non-fork
#' repos owned by `user`, via the GitHub REST API.
#'
#' @param user GitHub username (e.g., "mjfrigaard").
#' @param emails Character vector of author emails to match (case-insensitive).
#' @param since,until Optional date or POSIXct bounds.
#' @param include_forks Logical; include forked repos.
#' @return A tibble, one row per commit.
#' @export
collect_git_commits <- function(user,
                                emails = NULL,
                                since = NULL,
                                until = NULL,
                                include_forks = FALSE) {

  for (pkg in c("gh", "dplyr", "purrr", "tibble")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the '", pkg, "' package.", call. = FALSE)
    }
  }

  `%||%` <- function(x, y) if (is.null(x)) y else x

  iso <- function(x) {
    if (is.null(x)) return(NULL)
    format(as.POSIXct(x, tz = "UTC"), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  }

  # 1. List repos owned by user (paginated).
  repos <- gh::gh("/users/{user}/repos",
                  user = user, type = "owner",
                  per_page = 100, .limit = Inf)

  if (!include_forks) {
    repos <- Filter(function(r) isFALSE(r$fork), repos)
  }
  repo_names <- vapply(repos, `[[`, character(1), "name")
  message("Found ", length(repo_names), " repos for '", user, "'.")

  # 2. For each repo, pull commits — once per email (API filters one at a time).
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

  # 3. Defensive post-filter (API `author` is fuzzy).
  if (!is.null(emails)) {
    all_commits <- dplyr::filter(
      all_commits,
      tolower(.data$author_email) %in% tolower(emails)
    )
  }

  # 4. Derived columns consumed by the plot functions.
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
