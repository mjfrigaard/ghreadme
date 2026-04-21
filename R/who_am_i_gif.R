#' Create a GIF of who_am_i() console output
#'
#' Records each message from [who_am_i()] as a ggplot frame using
#' `camcorder`, then renders the frames to a gif with `gifski`.
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
#' @param frame_duration seconds each frame is shown (default `1.5`)
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
                          frame_duration = 1.5) {

  if (!requireNamespace("camcorder", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg camcorder} is required.",
      "i" = "Install with: {.code install.packages('camcorder')}"
    )
  }
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

  camcorder::gg_record(
    dir    = tempdir(),
    device = "png",
    width  = width,
    height = height,
    units  = "px",
    dpi    = 96,
    bg     = "#1e1e1e"
  )

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
    print(p)
  }

  camcorder::gg_playback(
    name                 = output,
    first_image_duration = 1,
    last_image_duration  = 4,
    frame_duration       = frame_duration,
    image_resize         = width
  )

  invisible(output)
}
