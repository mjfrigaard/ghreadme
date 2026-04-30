#' Punchcard plot: commits by weekday and hour of day
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector). `NULL` aggregates all repos.
#' @param date_begin,date_end Optional Date bounds.
#' @param title Plot title. Defaults to repo name(s) or "All repos".
#' @param point_color Fill color for the circles.
#' @return A ggplot2 object.
#' @export
punchcard_plot <- function(commits,
                           repo = NULL,
                           date_begin = NULL,
                           date_end = NULL,
                           title = NULL,
                           point_color = "#1f6feb") {

  for (pkg in c("dplyr", "ggplot2", "tidyr")) {
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

  # --- aggregate and pad missing cells (so grid is always 7x24) -----------
  wday_levels <- c("Monday","Tuesday","Wednesday","Thursday",
                   "Friday","Saturday","Sunday")

  grid <- tidyr::expand_grid(
    weekday = factor(wday_levels, levels = rev(wday_levels)),
    hour    = 0:23
  )

  per_cell <- commits |>
    dplyr::mutate(weekday = factor(as.character(.data$weekday),
                                   levels = rev(wday_levels))) |>
    dplyr::count(.data$weekday, .data$hour, name = "commits")

  df <- dplyr::left_join(grid, per_cell, by = c("weekday", "hour")) |>
    dplyr::mutate(commits = dplyr::coalesce(.data$commits, 0L))

  ggplot2::ggplot(df, ggplot2::aes(x = .data$hour, y = .data$weekday, size = .data$commits)) +
    ggplot2::geom_point(
      data  = subset(df, df$commits > 0),
      shape = 21, fill = point_color, color = "white", stroke = 0.4
    ) +
    ggplot2::scale_size_area(max_size = 14, name = "commits") +
    ggplot2::scale_x_continuous(
      breaks = seq(0, 23, by = 2),
      labels = sprintf("%02d:00", seq(0, 23, by = 2)),
      limits = c(-0.5, 23.5), expand = c(0, 0)
    ) +
    ggplot2::labs(
      title = paste0(title, " — ", sum(df$commits), " commits"),
      x = NULL, y = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(color = "grey92"),
      axis.text.x      = ggplot2::element_text(size = 9)
    )
}
