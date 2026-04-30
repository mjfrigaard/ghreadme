make_test_commits <- function(n_repos   = 3,
                              n_commits = 30,
                              start     = "2023-01-15",
                              end       = "2024-12-15") {
  stopifnot(n_commits >= n_repos)
  repos <- paste0("repo-", letters[seq_len(n_repos)])
  repo_vec <- rep(repos, length.out = n_commits)

  timestamps <- seq(
    as.POSIXct(paste(start, "09:00:00"), tz = "UTC"),
    as.POSIXct(paste(end,   "17:00:00"), tz = "UTC"),
    length.out = n_commits
  )

  base <- tibble::tibble(
    repo         = sort(repo_vec),
    sha          = paste0("sha", sprintf("%04d", seq_len(n_commits))),
    timestamp    = timestamps,
    author_name  = "Test User",
    author_email = "test@example.com",
    message      = paste("commit", seq_len(n_commits))
  )

  base |>
    dplyr::mutate(
      local_ts = as.POSIXct(format(.data$timestamp, tz = "UTC"), tz = "UTC"),
      date     = as.Date(.data$local_ts),
      hour     = as.integer(format(.data$local_ts, "%H")),
      weekday  = factor(
        weekdays(.data$date),
        levels = c("Monday","Tuesday","Wednesday","Thursday",
                   "Friday","Saturday","Sunday")
      ),
      year     = as.integer(format(.data$date, "%Y"))
    )
}

with_null_graphics <- function(code) {
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  force(code)
}
