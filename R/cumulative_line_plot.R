#' Cumulative commits over time, one line per repo
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector). `NULL` uses all repos.
#' @param date_begin,date_end Optional Date bounds.
#' @param top_n Keep this many most-active repos as their own lines;
#'   only applied when `repo` is `NULL`.
#' @param show_other If `TRUE`, roll the non-top repos into an "Other" line.
#' @param title Plot title.
#' @return A ggplot2 object.
#' @export
cumulative_line_plot <- function(commits,
                                 repo = NULL,
                                 date_begin = NULL,
                                 date_end   = NULL,
                                 top_n      = 10,
                                 show_other = TRUE,
                                 title      = NULL) {

  for (pkg in c("dplyr", "ggplot2", "tidyr", "scales")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the '", pkg, "' package.", call. = FALSE)
    }
  }

  # --- filter -------------------------------------------------------------
  if (!is.null(repo)) {
    commits <- commits[commits$repo %in% repo, , drop = FALSE]
  }
  if (!is.null(date_begin)) {
    commits <- commits[commits$date >= as.Date(date_begin), , drop = FALSE]
  }
  if (!is.null(date_end)) {
    commits <- commits[commits$date <= as.Date(date_end), , drop = FALSE]
  }
  if (nrow(commits) == 0) stop("No commits after filtering.", call. = FALSE)

  if (is.null(title)) {
    title <- if (is.null(repo)) "All repos" else paste(repo, collapse = ", ")
  }

  # --- choose lines: top_n repos, optional "Other" bucket -----------------
  repo_totals <- commits |>
    dplyr::count(.data$repo, sort = TRUE, name = "n")

  top_repos <- utils::head(repo_totals$repo, top_n)

  commits <- commits |>
    dplyr::mutate(
      repo_group = ifelse(.data$repo %in% top_repos, .data$repo, "Other")
    )

  if (!show_other) {
    commits <- dplyr::filter(commits, .data$repo_group != "Other")
  }

  # --- daily counts, then cumulative sum per repo_group -------------------
  per_day <- commits |>
    dplyr::count(.data$repo_group, .data$date, name = "commits") |>
    dplyr::arrange(.data$repo_group, .data$date) |>
    dplyr::group_by(.data$repo_group) |>
    dplyr::mutate(cumulative = cumsum(.data$commits)) |>
    dplyr::ungroup()

  # Order legend by final cumulative total (descending); Other last.
  lvls <- per_day |>
    dplyr::group_by(.data$repo_group) |>
    dplyr::summarize(total = max(.data$cumulative), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(.data$total)) |>
    dplyr::pull(.data$repo_group)
  if ("Other" %in% lvls) lvls <- c(setdiff(lvls, "Other"), "Other")

  per_day$repo_group <- factor(per_day$repo_group, levels = lvls)

  ggplot2::ggplot(per_day,
                  ggplot2::aes(x = .data$date, y = .data$cumulative,
                               color = .data$repo_group, group = .data$repo_group)) +
    ggplot2::geom_step(linewidth = 0.7) +
    ggplot2::scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
    ggplot2::scale_y_continuous(labels = scales::comma) +
    ggplot2::labs(
      title = paste0(title, " — cumulative commits"),
      x = NULL, y = "Cumulative commits",
      color = "repo"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position  = "right"
    )
}
