#' Spiral plot of daily commit counts (points)
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector of names). `NULL` aggregates
#'   across all repos in `commits`.
#' @param date_begin,date_end Optional Date bounds.
#' @param title Legend/plot title. Defaults to repo name(s) or "All repos".
#' @return Invisibly returns the per-day commit summary used for plotting.
#' @export
spiral_points_plot <- function(commits,
                               repo = NULL,
                               date_begin = NULL,
                               date_end = NULL,
                               title = NULL) {

  for (pkg in c("spiralize", "ComplexHeatmap", "circlize",
                "grid", "dplyr", "lubridate")) {
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

  # --- aggregate to 1 row per date ----------------------------------------
  df <- commits |>
    dplyr::count(.data$date, name = "commits") |>
    dplyr::arrange(.data$date)

  if (is.null(title)) {
    title <- if (is.null(repo)) "All repos" else paste(repo, collapse = ", ")
  }

  # --- helper ------------------------------------------------------------
  calc_pt_size <- function(x, x_max, x_min = 2, pt_max = 20, pt_min = 1) {
    s <- (pt_max - pt_min) / (x_max - x_min) * (x - x_min) + pt_min
    pmin(pmax(s, pt_min), pt_max)
  }
  max_commit <- max(30, max(df$commits) * 0.9)

  # --- spiral ------------------------------------------------------------
  spiralize::spiral_initialize_by_time(range(df$date),
                                       verbose = FALSE,
                                       normalize_year = TRUE)
  spiralize::spiral_track()
  spiralize::spiral_points(
    df$date, 0.5, pch = 16,
    size = grid::unit(calc_pt_size(df$commits, x_max = max_commit), "pt")
  )

  breaks <- grid::grid.pretty(range(df$commits))
  lgd <- ComplexHeatmap::Legend(
    title = paste0(title, " commits\n(total ", sum(df$commits), ")"),
    at    = breaks,
    type  = "points",
    size  = grid::unit(calc_pt_size(breaks, x_max = max_commit), "pt")
  )
  ComplexHeatmap::draw(lgd,
    x    = grid::unit(0.5, "mm"),
    y    = grid::unit(1, "npc") - grid::unit(1, "mm"),
    just = c("left", "top"))

  yrs <- unique(lubridate::year(df$date))
  spiralize::spiral_text(
    paste0(yrs, "-01-01"), 0.5, yrs,
    gp = grid::gpar(fontsize = 6, col = "black"), facing = "inside"
  )

  invisible(df)
}
