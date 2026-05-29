#' Scaffold a profile README.Rmd
#'
#' Drops a starter `README.Rmd` into the target directory, pre-wired to call
#' [who_am_i()] and [gh_badges()] (with commented-out chunks for
#' [who_am_i_gif()] and [so_rep()]). Knit it to regenerate `README.md` for
#' your GitHub profile repo.
#'
#' @param name,likes,learn,work,collab Values substituted into the
#'   [who_am_i()] call. Each defaults to an editable placeholder.
#' @param username GitHub username substituted into the [gh_badges()] call.
#' @param path Directory to write `README.Rmd` into. Defaults to the
#'   current working directory.
#' @param overwrite Logical; replace an existing `README.Rmd`?
#' @param open Logical; open the new file in the editor when interactive.
#'
#' @return Invisibly returns the path to the written file.
#' @export
#'
#' @importFrom cli cli_alert_success cli_alert_info cli_abort
#'
#' @examples
#' \dontrun{
#' use_profile_readme(
#'   name     = "Martin",
#'   likes    = "#rstats and data visualization.",
#'   learn    = "Shiny app development, Python, and Linux",
#'   work     = "R package development tools.",
#'   collab   = "#rstats packages for data science.",
#'   username = "mjfrigaard"
#' )
#' }
use_profile_readme <- function(name      = "Your Name",
                                likes     = "your interests",
                                learn     = "what you're learning",
                                work      = "what you're working on",
                                collab    = "what you'd like to collaborate on",
                                username  = "your-github-username",
                                path      = ".",
                                overwrite = FALSE,
                                open      = interactive()) {

  out <- file.path(path, "README.Rmd")
  if (file.exists(out) && !overwrite) {
    cli::cli_abort(c(
      "{.file {out}} already exists.",
      "i" = "Use {.code overwrite = TRUE} to replace it."
    ))
  }

  tmpl <- system.file("templates", "profile-README.Rmd",
                      package = "ghreadme", mustWork = TRUE)
  content <- readLines(tmpl)

  subs <- list(
    "{{name}}"     = name,
    "{{likes}}"    = likes,
    "{{learn}}"    = learn,
    "{{work}}"     = work,
    "{{collab}}"   = collab,
    "{{username}}" = username
  )
  for (key in names(subs)) {
    content <- gsub(key, subs[[key]], content, fixed = TRUE)
  }

  writeLines(content, out)
  cli::cli_alert_success("Wrote {.file {out}}")
  cli::cli_alert_info(
    "Edit the placeholders, then knit to regenerate {.file README.md}."
  )

  if (isTRUE(open) && interactive()) {
    try(utils::file.edit(out), silent = TRUE)
  }

  invisible(out)
}
