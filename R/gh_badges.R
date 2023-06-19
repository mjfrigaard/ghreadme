#' Get GitHub badges
#'
#' @description
#' GitHub badges from [vercel](https://github-profile-summary-cards.vercel.app/demo.html)
#'
#' @noRd
#'
#' @param x badge
#'
#' @return badges from vercel.app
#'
get_gh_badge <- function(x) {
  switch(x,
    details = "profile-details",
    commit_lang = "most-commit-language",
    ptime = "productive-time",
    repo_lang = "repos-per-language",
    stats = "stats")
}
#' Create GitHub badges
#'
#' @description
#' GitHub badges from [vercel](https://github-profile-summary-cards.vercel.app/demo.html)
#'
#' @export gh_badges
#'
#' @param username GitHub username
#' @param badge name of badge ("details", "commit_lang", "ptime", "repo_lang", "stats")
#'
#' @importFrom glue glue
#' @importFrom purrr map_vec
#'
#' @return Markdown links for badges from github-profile-summary-cards.vercel.app API
#' gh_badges(username = "mjfrigaard", badge = c("details", "stats"), theme = "dark")
gh_badges <- function(username, badge, theme) {
  gh_theme <- switch(theme,
    default = "default",
    dark = "github_dark",
    light = "github_light")

  if (length(badge) > 1) {
  gh_badges <- purrr::map_vec(badge, get_gh_badge)
  glue::glue(
    "![](http://github-profile-summary-cards.vercel.app/api/cards/{gh_badges}?username={username}&theme={gh_theme})")
  } else {
  gh_badge <- get_gh_badge(x = badge)
  glue::glue(
    "![](http://github-profile-summary-cards.vercel.app/api/cards/{gh_badge}?username={username}&theme={gh_theme})")
  }
}

gh_badges(username = "mjfrigaard", badge = c("details", "stats"), theme = "dark")
