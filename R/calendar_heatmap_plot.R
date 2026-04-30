#' GitHub-style calendar heatmap of daily commit counts
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector). `NULL` aggregates all repos.
#' @param date_begin,date_end Optional Date bounds.
#' @param title Plot title. Defaults to repo name(s) or "All repos".
#' @param week_start "Sunday" (GitHub default) or "Monday" (ISO).
#' @param low,high Hex colors for the fill gradient endpoints.
#' @return A ggplot2 object.
#' @export
calendar_heatmap_plot <- function(commits,
                                  repo = NULL,
                                  date_begin = NULL,
                                  date_end = NULL,
                                  title = NULL,
                                  week_start = c("Sunday", "Monday"),
                                  low  = "#ebedf0",
                                  high = "#216e39") {

  for (pkg in c("dplyr", "ggplot2")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the '", pkg, "' package.", call. = FALSE)
    }
  }
  week_start <- match.arg(week_start)

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

  # --- aggregate and pad to a full date grid ------------------------------
  per_day <- dplyr::count(commits, .data$date, name = "commits")

  full_range <- seq(min(per_day$date), max(per_day$date), by = "day")
  wfmt <- if (week_start == "Sunday") "%U" else "%W"
  wday_levels <- if (week_start == "Sunday") {
    c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  } else {
    c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
  }

  full <- dplyr::tibble(date = full_range) |>
    dplyr::left_join(per_day, by = "date") |>
    dplyr::mutate(
      commits = dplyr::coalesce(.data$commits, 0L),
      year    = as.integer(format(.data$date, "%Y")),
      week    = as.integer(format(.data$date, wfmt)),
      wday    = factor(weekdays(.data$date), levels = rev(wday_levels))
    )

  # month labels at approximate week positions
  month_breaks <- c(1, 5, 9, 13, 17, 22, 26, 31, 35, 39, 44, 48)

  ggplot2::ggplot(full, ggplot2::aes(x = .data$week, y = .data$wday, fill = .data$commits)) +
    ggplot2::geom_tile(color = "white", linewidth = 0.3) +
    ggplot2::facet_wrap(~ year, ncol = 1, strip.position = "left") +
    ggplot2::scale_fill_gradient(low = low, high = high, name = "commits") +
    ggplot2::scale_x_continuous(breaks = month_breaks,
                                labels = month.abb,
                                expand = c(0, 0)) +
    ggplot2::coord_equal() +
    ggplot2::labs(
      title = paste0(title, " — ", sum(full$commits), " commits"),
      x = NULL, y = NULL
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid        = ggplot2::element_blank(),
      axis.ticks        = ggplot2::element_blank(),
      strip.text.y.left = ggplot2::element_text(angle = 0, face = "bold"),
      legend.position   = "right"
    )
}
