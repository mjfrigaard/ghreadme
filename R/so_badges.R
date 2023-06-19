#' Stack Overflow Reputation Badge
#'
#' @param username SO username
#' @param user_id SO userID
#'
#' @return HTML for badge
#'
#' @export
#'
#' @examples
#' so_rep(username = "martin-frigaard", user_id = "4926446")
so_rep <- function(username, user_id) {
  glue::glue("
<a href='https://stackoverflow.com/users/{user_id}/{username}' target='_blank'>
<img alt='StackOverflow'
src='https://stackoverflow-badge.vercel.app/?userID={user_id}' />
</a>
    ")
}
