# Getting started with ghreadme

GitHub gives every user a “profile” repository (the one named the same
as your username) whose `README.md` is rendered on your profile page.
`ghreadme` lets you author that file as `README.Rmd` so the intro text,
GitHub stats, and any embedded GIFs stay in sync with the underlying R
code.

This vignette walks through the typical setup:

1.  Create the profile repo on GitHub.
2.  Scaffold a `README.Rmd` with
    [`use_profile_readme()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme.md).
3.  Knit and commit.
4.  Optionally automate the rebuild with
    [`use_profile_readme_action()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme_action.md).

## 1. Create the profile repo

On GitHub, create a new repository whose name matches your username
exactly (for example, a user `mjfrigaard` would create
`https://github.com/mjfrigaard/mjfrigaard`). Clone it locally and open
it in RStudio (or your editor of choice). The remaining steps assume
that repo is the working directory.

## 2. Scaffold the README

[`use_profile_readme()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme.md)
writes a starter `README.Rmd` into the current directory. The optional
arguments fill in placeholders inside the template; omit them and the
function writes `"Your Name"`-style placeholders you can edit by hand.

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

The result is a `README.Rmd` with three chunks:

- [`who_am_i()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i.md);
  the intro lines that appear at the top of your profile.
- [`gh_badges()`](https://mjfrigaard.github.io/ghreadme/reference/gh_badges.md);
  the vercel-hosted GitHub summary cards.
- A commented-out block for
  [`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
  and
  [`so_rep()`](https://mjfrigaard.github.io/ghreadme/reference/so_rep.md)
  you can flip on by setting `eval = TRUE` and uncommenting the
  surrounding HTML comment.

By default the function refuses to overwrite an existing `README.Rmd`.
Pass `overwrite = TRUE` if you want to regenerate the scaffold.

``` r

use_profile_readme(username = "mjfrigaard", overwrite = TRUE)
```

## 3. Knit and commit

Render the file with
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
(or the *Knit* button in RStudio). This regenerates `README.md`, which
is the file GitHub actually shows on your profile page.

``` r

rmarkdown::render("README.Rmd")
```

Commit both files:

``` bash
git add README.Rmd README.md
git commit -m "initial profile README"
git push
```

Visit `https://github.com/<username>` to see the rendered result.

## 4. Automate the rebuild

Profile READMEs feel best when the stats and (optional) GIF stay
current.
[`use_profile_readme_action()`](https://mjfrigaard.github.io/ghreadme/reference/use_profile_readme_action.md)
drops a GitHub Actions workflow into
`.github/workflows/profile-readme.yaml` that:

- runs on a cron schedule (default: Sunday 06:00 UTC) and on manual
  dispatch;
- installs `ghreadme` (and `rmarkdown`, `ggplot2`, `gifski`);
- renders `README.Rmd`;
- commits the regenerated `README.md` (and any GIF artifacts) if
  anything changed.

``` r

use_profile_readme_action()
```

Override the schedule by passing a different cron expression:

``` r

use_profile_readme_action(cron = "0 6 * * 1")  # Mondays at 06:00 UTC
```

If you maintain your own fork of `ghreadme`, point the workflow at it
with the `repo` argument:

``` r

use_profile_readme_action(repo = "your-user/your-fork")
```

Commit the workflow file and push:

``` bash
git add .github/workflows/profile-readme.yaml
git commit -m "schedule profile README rebuild"
git push
```

The workflow needs write access on the contents of the repo to push the
regenerated `README.md` back; it requests this via
`permissions: contents: write` in the YAML, which is enabled by default
for repos owned by your account.

## What gets rendered

A scaffolded README produces roughly this on your profile page:

         👋 Hi, my name is Martin.

         👀 I like #rstats and data visualization.

         🌱 I'm learning about Shiny app development, Python, and Linux

         📦 I'm currently working on R package development tools.

         💞 I'd love to collaborate on #rstats packages for data science.

         📫 Want to connect? Use the badges below...

followed by the GitHub summary cards from
[`gh_badges()`](https://mjfrigaard.github.io/ghreadme/reference/gh_badges.md).

## Next steps

- [`vignette("viz-git-gif")`](https://mjfrigaard.github.io/ghreadme/articles/viz-git-gif.md)
  covers turning the visualization functions
  ([`calendar_heatmap_plot()`](https://mjfrigaard.github.io/ghreadme/reference/calendar_heatmap_plot.md),
  [`punchcard_plot()`](https://mjfrigaard.github.io/ghreadme/reference/punchcard_plot.md),
  [`cumulative_line_plot()`](https://mjfrigaard.github.io/ghreadme/reference/cumulative_line_plot.md))
  into animated GIFs you can embed in the README.
- The
  [`who_am_i_gif()`](https://mjfrigaard.github.io/ghreadme/reference/who_am_i_gif.md)
  chunk inside the scaffold writes `intro.gif` next to `README.Rmd`;
  uncomment it and add `![](intro.gif)` above the badges to replace the
  plain-text intro with an animation.
