#' Create a GIF of who_am_i() console output
#'
#' Records each message from [who_am_i()] as a ggplot frame using
#' `ggplot2` and `ggsave()`, then assembles the frames into a GIF with `gifski`.
#'
#' @param name Your name
#' @param likes Your likes
#' @param learn What you're learning
#' @param work What you're currently working on
#' @param collab What you'd like to collaborate on
#' @param connect logical, include the connect message (default `TRUE`)
#' @param output path for the output gif (default `"intro.gif"`)
#' @param width gif width in pixels (default `800`)
#' @param height gif height in pixels (default `400`)
#' @param frame_duration seconds each middle frame is shown (default `1.5`)
#' @param first_duration seconds the first frame is shown (default `1`)
#' @param last_duration seconds the last frame is shown (default `4`)
#'
#' @return invisibly returns `output` path
#' @export
#'
#' @importFrom glue glue
#' @importFrom cli cli_abort
#'
#' @examples
#' \dontrun{
#' who_am_i_gif(
#'   name   = "Martin",
#'   likes  = "#rstats and data visualization.",
#'   learn  = "shiny app development, JavaScript, and Bayesian statistics.",
#'   work   = "R package development tools.",
#'   collab = "#rstats packages for data science.",
#'   output = "intro.gif"
#' )
#' }
who_am_i_gif <- function(name, likes, learn, work, collab,
                          connect        = TRUE,
                          output         = "intro.gif",
                          width          = 800,
                          height         = 400,
                          frame_duration = 1.5,
                          first_duration = 1,
                          last_duration  = 4) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg ggplot2} is required.",
      "i" = "Install with: {.code install.packages('ggplot2')}"
    )
  }

  messages <- c(
    glue::glue("\U0001f44b Hi, my name is {name}."),
    glue::glue("\U0001f440 I like {likes}"),
    glue::glue("\U0001f331 I'm learning about {learn}"),
    glue::glue("\U0001f4e6 I'm currently working on {work}"),
    glue::glue("\U0001f49e I'd love to collaborate on {collab}")
  )
  if (connect) {
    messages <- c(messages, "\U0001f4eb Want to connect? Use the badges below...")
  }

  n <- length(messages)

  # Unique temp dir per call to avoid stale frames from previous runs
  frame_dir <- file.path(tempdir(), paste0("who-am-i-frames-", as.integer(Sys.time())))
  dir.create(frame_dir, showWarnings = FALSE, recursive = TRUE)

  for (i in seq_along(messages)) {
    shown <- messages[seq_len(i)]
    y_pos <- n - seq(0, i - 1)

    p <- ggplot2::ggplot() +
      ggplot2::annotate(
        "text",
        x      = 0.05,
        y      = y_pos,
        label  = shown,
        hjust  = 0,
        vjust  = 0.5,
        colour = "#d4d4d4",
        size   = 5,
        family = "mono"
      ) +
      ggplot2::scale_x_continuous(limits = c(0, 1)) +
      ggplot2::scale_y_continuous(limits = c(0, n + 1)) +
      ggplot2::theme_void() +
      ggplot2::theme(
        plot.background  = ggplot2::element_rect(fill = "#1e1e1e", colour = NA),
        panel.background = ggplot2::element_rect(fill = "#1e1e1e", colour = NA)
      )

    ggplot2::ggsave(
      filename = file.path(frame_dir, sprintf("%04d.png", i)),
      plot     = p,
      width    = width,
      height   = height,
      units    = "px",
      dpi      = 96,
      bg       = "#1e1e1e"
    )
  }

  make_gif(
    frame_dir      = frame_dir,
    output         = output,
    width          = width,
    height         = height,
    first_duration = first_duration,
    frame_duration = frame_duration,
    last_duration  = last_duration
  )

  invisible(output)
}
