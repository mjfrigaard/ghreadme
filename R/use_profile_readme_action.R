#' Scaffold a GitHub Action that rebuilds the profile README on a schedule
#'
#' Drops `.github/workflows/profile-readme.yaml` into the repo. The workflow
#' installs `ghreadme` from GitHub, renders `README.Rmd` on a cron schedule
#' (and on manual dispatch), and commits the result if it changed.
#'
#' @param cron Cron expression for when the action runs. Default
#'   `"0 6 * * 0"` (Sunday 06:00 UTC).
#' @param repo GitHub `owner/name` to install `ghreadme` from. Default
#'   `"mjfrigaard/ghreadme"`.
#' @param path Repo root to write into. Defaults to the current directory.
#' @param overwrite Logical; replace an existing workflow file?
#'
#' @return Invisibly returns the path to the written workflow.
#' @export
#'
#' @importFrom cli cli_alert_success cli_alert_info cli_abort
#'
#' @examples
#' \dontrun{
#' use_profile_readme_action()
#' use_profile_readme_action(cron = "0 6 * * 1")  # Mondays at 06:00 UTC
#' }
use_profile_readme_action <- function(cron      = "0 6 * * 0",
                                       repo      = "mjfrigaard/ghreadme",
                                       path      = ".",
                                       overwrite = FALSE) {

  wf_dir <- file.path(path, ".github", "workflows")
  dir.create(wf_dir, showWarnings = FALSE, recursive = TRUE)

  out <- file.path(wf_dir, "profile-readme.yaml")
  if (file.exists(out) && !overwrite) {
    cli::cli_abort(c(
      "{.file {out}} already exists.",
      "i" = "Use {.code overwrite = TRUE} to replace it."
    ))
  }

  tmpl <- system.file("templates", "profile-readme-action.yaml",
                      package = "ghreadme", mustWork = TRUE)
  content <- readLines(tmpl)
  content <- gsub("{{cron}}", cron, content, fixed = TRUE)
  content <- gsub("{{repo}}", repo, content, fixed = TRUE)

  writeLines(content, out)
  cli::cli_alert_success("Wrote {.file {out}}")
  cli::cli_alert_info(
    "Action runs on cron {.val {cron}} and on manual dispatch."
  )

  invisible(out)
}
