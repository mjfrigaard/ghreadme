
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ghreadme`

The goal of `ghreadme` is to create your GitHub profile `README.md`
using [R Markdown.](https://rmarkdown.rstudio.com/)

## Installation

You can install the development version of `ghreadme` like so:

``` r
remotes::install_github("mjfrigaard/ghreadme")
```

## Quick start

First, create a profile repository on GitHub whose name matches your
username (i.e., `https://github.com/<username>/<username>`) and clone it
locally. Then scaffold a starter `README.Rmd` from R:

``` r
library(ghreadme)

use_profile_readme(
  name     = "Martin",
  likes    = "#rstats and data visualization.",
  learn    = "Shiny app development, Python, and Linux",
  work     = "R package development tools.",
  collab   = "#rstats packages for data science.",
  username = "mjfrigaard"
)
```

`use_profile_readme()` writes a starter `README.Rmd` pre-wired to call
`who_am_i()` and `gh_badges()`, with commented-out chunks for
`who_am_i_gif()` and `so_rep()` you can switch on. Knit the file (or
click *Knit* in RStudio) to regenerate `README.md`, then commit both
files and push.

## Automate the rebuild

`use_profile_readme_action()` drops a GitHub Actions workflow into
`.github/workflows/profile-readme.yaml` that re-renders `README.Rmd` on
a schedule so your stats (and any embedded GIFs) stay current:

``` r
use_profile_readme_action()                    # Sundays at 06:00 UTC
use_profile_readme_action(cron = "0 6 * * 1")  # Mondays at 06:00 UTC
```

The workflow installs `ghreadme`, renders `README.Rmd`, and commits the
regenerated `README.md` (and any GIF artifacts) if anything changed.

See `vignette("ghreadme")` for the full walkthrough.

## What the scaffold generates

### `who_am_i()`

``` r
library(ghreadme)
```

``` r
who_am_i(name = "Martin",
  likes = "#rstats and data visualization.",
  learn = "Shiny app development, Python, and Linux",
  work = "R package development tools.",
  collab = "#rstats packages for data science."
  )
```

         👋 Hi, my name is Martin.

         👀 I like #rstats and data visualization.

         🌱 I'm learning about Shiny app development, Python, and Linux

         📦 I'm currently working on R package development tools.

         💞 I'd love to collaborate on #rstats packages for data science.

         📫 Want to connect? Use the badges below...

### GitHub badges

For GitHub badges from
[vercel.app](https://github-profile-summary-cards.vercel.app/demo.html),
include the call in a code chunk with `results` set to `asis`.

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

### Stack Overflow reputation

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

## Visualizing your git history

`ghreadme` also includes commit-history visualizations
(`calendar_heatmap_plot()`, `punchcard_plot()`,
`cumulative_line_plot()`, and the spiral plots) plus a `make_gif()`
helper for stitching frames together. See `vignette("viz-git-gif")` for
recipes.
