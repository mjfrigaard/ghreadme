
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ghreadme`

The goal of `ghreadme` is to create your GitHub profile `README.md`

## Installation

You can install the development version of `ghreadme` like so:

``` r
remotes::install_github("mjfrigaard/ghreadme")
```

## Example

This is a basic example which shows you how to solve a common problem:

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

``` r
gh_badges(username = "mjfrigaard", 
  badge = c("details", "stats"), 
  theme = "dark")
```

![](http://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=mjfrigaard&theme=github_dark)
![](http://github-profile-summary-cards.vercel.app/api/cards/stats?username=mjfrigaard&theme=github_dark)
