# Create GitHub badges

GitHub badges from
[vercel](https://github-profile-summary-cards.vercel.app/demo.html)

## Usage

``` r
gh_badges(username, badge, theme)
```

## Arguments

- username:

  GitHub username

- badge:

  name of badge ("details", "commit_lang", "ptime", "repo_lang",
  "stats")

## Value

Markdown links for badges from github-profile-summary-cards.vercel.app
API gh_badges(username = "mjfrigaard", badge = c("details", "stats"),
theme = "dark")
