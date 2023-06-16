#' Introduce Yourself
#'
#' @param name Your name
#' @param likes Your likes
#' @param learn What you're learning
#' @param work What you're currently working on
#' @param collab What you'd like to collaborate on
#' @param connect logical (TRUE/FALSE)
#'
#' @return printed intro
#' @export who_am_i
#'
#' @importFrom glue glue
#' @importFrom cli cli_text
#'
#' @examples
#' who_am_i(name = "Martin",
#' likes = "#rstats and data visualization.",
#' learn = "shiny app development, JavaScript, and Bayesian statistics.",
#' work = "R package development tools.",
#' collab = "#rstats packages for data science.")
who_am_i <- function(name, likes, learn, work, collab, connect = TRUE){
  cli::cli_text(
    glue::glue("👋 Hi, my name is {name}.")
    )
  cli::cli_text(glue::glue("👀 I like {likes}"))
  cli::cli_text(glue::glue("🌱 I'm learning about {learn}"))
  cli::cli_text(glue::glue("📦 I'm currently working on {work}"))
  cli::cli_text(glue::glue("💞 I'd love to collaborate on {collab}"))
  if (connect) {
    cli::cli_text("📫 Want to connect? Use the badges below...")
  }
}


