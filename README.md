
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ghreadme`

The goal of `ghreadme` is to create your GitHub profile `README.md`

## Installation

You can install the development version of `ghreadme` like so:

``` r
remotes::install_github("mjfrigaard/ghreadme")
```

## Example

Load the package, create a repo with the same name as your username
(i.e., `https://github.com/<username>/<username>`), then add the
following to your `README.Rmd` file (set `echo=FALSE` to hide the code).

``` r
library(ghreadme)
```

``` r
who_am_i(name = "Martin",
likes = "#rstats and data visualization.",
learn = "shiny app development, JavaScript, and Bayesian statistics.",
work = "R package development tools.",
collab = "#rstats packages for data science.")
```

         👋 Hi, my name is Martin.

         👀 I like #rstats and data visualization.

         🌱 I'm learning about shiny app development, JavaScript, and Bayesian
         statistics.

         📦 I'm currently working on R package development tools.

         💞 I'd love to collaborate on #rstats packages for data science.

         📫 Want to connect? Use the badges below...

## GitHub badges

For GitHub badges from
[vercel.app](https://github-profile-summary-cards.vercel.app/demo.html),
include the call in a code chunk with `results` set to `asis`.

Example:

```` default
```{r gh_badges, results='asis'}
gh_badges(username = "mjfrigaard", 
  badge = c("details", "stats", "repo_lang"), 
  theme = "dark")
```
````

![](http://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=mjfrigaard&theme=github_dark)
![](http://github-profile-summary-cards.vercel.app/api/cards/stats?username=mjfrigaard&theme=github_dark)
![](http://github-profile-summary-cards.vercel.app/api/cards/repos-per-language?username=mjfrigaard&theme=github_dark)

## Stack Overflow reputation

Example:

```` default
```{r so_rep, results='asis'}
so_rep(
  username = "martin-frigaard", 
  user_id = "4926446")
```
````

<a href='https://stackoverflow.com/users/4926446/martin-frigaard' target='_blank'>
<img alt='StackOverflow'
src='https://stackoverflow-badge.vercel.app/?userID=4926446' /> </a>
