#' Assemble a directory of PNG frames into a GIF
#'
#' Collects every `.png` file in `frame_dir` (sorted alphabetically), builds
#' a per-frame delay vector with distinct hold times for the first and last
#' frames, and writes the result to a GIF via [gifski::gifski()].
#'
#' The typical workflow is:
#' 1. Create a temporary directory.
#' 2. Loop over your data, saving one plot per frame with [ggplot2::ggsave()].
#' 3. Call `make_gif()` to assemble the frames.
#'
#' @param frame_dir Path to a directory containing numbered `.png` frame files.
#' @param output Path for the output `.gif` file (e.g. `"animation.gif"`).
#' @param width GIF width in pixels.
#' @param height GIF height in pixels.
#' @param first_duration Seconds to hold the first frame (default `1`).
#' @param frame_duration Seconds to show each middle frame (default `0.4`).
#' @param last_duration Seconds to hold the last frame (default `4`).
#'
#' @return Invisibly returns `output`.
#' @export
#'
#' @importFrom cli cli_abort
#'
#' @examples
#' \dontrun{
#' frame_dir <- file.path(tempdir(), "my-frames")
#' dir.create(frame_dir, showWarnings = FALSE)
#'
#' for (i in 1:5) {
#'   p <- ggplot2::ggplot() + ggplot2::ggtitle(paste("Frame", i))
#'   ggplot2::ggsave(
#'     filename = file.path(frame_dir, sprintf("%04d.png", i)),
#'     plot     = p,
#'     width    = 800,
#'     height   = 400,
#'     units    = "px"
#'   )
#' }
#'
#' make_gif(frame_dir, "animation.gif", width = 800, height = 400)
#' }
make_gif <- function(frame_dir, output, width, height,
                     first_duration = 1,
                     frame_duration = 0.4,
                     last_duration  = 4) {

  if (!requireNamespace("gifski", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg gifski} is required.",
      "i" = "Install with: {.code install.packages('gifski')}"
    )
  }

  png_files <- sort(list.files(frame_dir, pattern = "\\.png$", full.names = TRUE))
  n <- length(png_files)

  if (n == 0L) {
    cli::cli_abort("No PNG frames found in: {.path {frame_dir}}")
  }

  delays <- c(first_duration, rep(frame_duration, max(0L, n - 2L)), last_duration)
  if (n == 1L) delays <- last_duration

  gifski::gifski(
    png_files = png_files,
    gif_file  = output,
    width     = width,
    height    = height,
    delay     = delays
  )

  invisible(output)
}
