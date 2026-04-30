#' Spiral heatmap of daily commit counts
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector). `NULL` aggregates all repos.
#' @param date_begin,date_end Optional Date bounds.
#' @param title Legend title. Defaults to repo name(s) or "All repos".
#' @return Invisibly returns the per-day commit summary.
#' @export
spiral_heatmap_plot <- function(commits,
                                repo = NULL,
                                date_begin = NULL,
                                date_end = NULL,
                                title = NULL) {

  for (pkg in c("spiralize", "ComplexHeatmap", "circlize",
                "RColorBrewer", "grid", "dplyr", "lubridate")) {
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

  # --- aggregate ----------------------------------------------------------
  df <- commits |>
    dplyr::count(.data$date, name = "commits") |>
    dplyr::arrange(.data$date)

  if (is.null(title)) {
    title <- if (is.null(repo)) "All repos" else paste(repo, collapse = ", ")
  }

  max_commit <- max(30, max(df$commits) * 0.9)
  col_fun <- circlize::colorRamp2(
    seq(2, max_commit, length.out = 11),
    rev(RColorBrewer::brewer.pal(11, "Spectral"))
  )

  # --- spiral -------------------------------------------------------------
  spiralize::spiral_initialize_by_time(range(df$date),
                                       verbose = FALSE,
                                       normalize_year = TRUE)
  spiralize::spiral_track()
  spiralize::spiral_rect(
    df$date, spiralize::TRACK_META$ylim[1],
    df$date, spiralize::TRACK_META$ylim[2],
    gp = grid::gpar(fill = col_fun(df$commits), col = NA)
  )

  lgd <- ComplexHeatmap::Legend(
    title  = paste0(title, " commits\n(total ", sum(df$commits), ")"),
    col_fun = col_fun
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
