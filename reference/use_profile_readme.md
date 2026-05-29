# Scaffold a profile README.Rmd

Drops a starter `README.Rmd` into the target directory, pre-wired to
call
[`who_am_i()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i.md)
and
[`gh_badges()`](https://mjfrigaard.github.io/ghreadme/reference/gh_badges.md)
(with commented-out chunks for
[`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
and
[`so_rep()`](https://mjfrigaard.github.io/ghreadme/reference/so_rep.md)).
Knit it to regenerate `README.md` for your GitHub profile repo.

## Usage

``` r
use_profile_readme(
  name = "Your Name",
  likes = "your interests",
  learn = "what you're learning",
  work = "what you're working on",
  collab = "what you'd like to collaborate on",
  username = "your-github-username",
  path = ".",
  overwrite = FALSE,
  open = interactive()
)
```

## Arguments

- name, likes, learn, work, collab:

  Values substituted into the
  [`who_am_i()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i.md)
  call. Each defaults to an editable placeholder.

- username:

  GitHub username substituted into the
  [`gh_badges()`](https://mjfrigaard.github.io/ghreadme/reference/gh_badges.md)
  call.

- path:

  Directory to write `README.Rmd` into. Defaults to the current working
  directory.

- overwrite:

  Logical; replace an existing `README.Rmd`?

- open:

  Logical; open the new file in the editor when interactive.

## Value

Invisibly returns the path to the written file.

## Examples

``` r
if (FALSE) { # \dontrun{
use_profile_readme(
  name     = "Martin",
  likes    = "#rstats and data visualization.",
  learn    = "Shiny app development, Python, and Linux",
  work     = "R package development tools.",
  collab   = "#rstats packages for data science.",
  username = "mjfrigaard"
)
} # }
```
