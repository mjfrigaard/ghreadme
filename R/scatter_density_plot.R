#' Scatter of commits across two dimensions (repo / time / date / weekday)
#'
#' @param commits Tidy data frame from `collect_git_commits()`.
#' @param repo Optional repo name (or vector). `NULL` uses all repos.
#' @param date_begin,date_end Optional Date bounds.
#' @param x,y One of "repo", "time", "date", "weekday" (must differ).
#' @param plot_type "ggplot", "plotly", or "density" (ggplot + marginal densities).
#' @param top_n When `repo` is an axis and `repo` arg is `NULL`, keep this
#'   many most-active repos (rest dropped to keep the axis readable).
#' @param title Plot title.
#' @return A ggplot, plotly, or ggExtra object.
#' @export
scatter_density_plot <- function(commits,
                                 repo       = NULL,
                                 date_begin = NULL,
                                 date_end   = NULL,
                                 x          = "date",
                                 y          = "time",
                                 plot_type  = c("ggplot", "plotly", "density"),
                                 top_n      = 15,
                                 title      = NULL) {

  for (pkg in c("dplyr", "ggplot2", "scales")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the '", pkg, "' package.", call. = FALSE)
    }
  }
  plot_type <- match.arg(plot_type)

  allowed <- c("repo", "time", "date", "weekday")
  if (x == y || !all(c(x, y) %in% allowed)) {
    stop('`x` and `y` must each be one of "repo", "time", "date", "weekday" and must differ.',
         call. = FALSE)
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

  # If `repo` is an axis and we haven't explicitly restricted it,
  # limit to the top_n most-active repos so the axis is readable.
  if (is.null(repo) && "repo" %in% c(x, y)) {
    keep <- commits |>
      dplyr::count(.data$repo, sort = TRUE, name = "n") |>
      utils::head(top_n) |>
      dplyr::pull(.data$repo)
    commits <- commits[commits$repo %in% keep, , drop = FALSE]
  }

  # --- derive time columns used by the plot ------------------------------
  commits <- commits |>
    dplyr::mutate(
      time_short = format(.data$local_ts, "%H:%M"),
      time       = as.POSIXct(.data$time_short, format = "%H:%M", tz = "UTC")
    ) |>
    droplevels()

  if (is.null(title)) {
    title <- if (is.null(repo)) "All repos" else paste(repo, collapse = ", ")
  }

  # --- base plot ---------------------------------------------------------
  p <- ggplot2::ggplot(
    commits,
    ggplot2::aes(x = .data[[x]], y = .data[[y]], label = .data$time_short)
  ) +
    ggplot2::geom_point(
      ggplot2::aes(fill = .data$repo),
      color = "#555555", size = 4, shape = 21, alpha = 0.85,
      position = ggplot2::position_jitter(width = 0.2, height = 0.2)
    ) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::theme(legend.position = "bottom")

  axis_scale <- function(p, var, axis) {
    scale_date <- if (axis == "x") ggplot2::scale_x_date   else ggplot2::scale_y_date
    scale_dt   <- if (axis == "x") ggplot2::scale_x_datetime else ggplot2::scale_y_datetime
    if (var == "date") {
      p + scale_date()
    } else if (var == "time") {
      p + scale_dt(labels = scales::date_format("%H:00"),
                   date_breaks = "2 hour")
    } else {
      p
    }
  }
  p <- axis_scale(p, x, "x")
  p <- axis_scale(p, y, "y")

  if (x %in% c("repo", "weekday")) {
    p <- p + ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
    )
  }

  # --- output variant ----------------------------------------------------
  if (plot_type == "plotly") {
    if (!requireNamespace("plotly", quietly = TRUE)) {
      stop("Install the 'plotly' package.", call. = FALSE)
    }
    tooltip <- if (x == "time") c("fill", "label", "y")
               else if (y == "time") c("fill", "x", "label")
               else c("fill", "x", "y")
    plotly::ggplotly(p, tooltip = tooltip)
  } else if (plot_type == "density") {
    if (!requireNamespace("ggExtra", quietly = TRUE)) {
      stop("Install the 'ggExtra' package.", call. = FALSE)
    }
    ggExtra::ggMarginal(p, type = "density", groupFill = FALSE)
  } else {
    p
  }
}
