# Introduce Yourself

Introduce Yourself

## Usage

``` r
who_am_i(name, likes, learn, work, collab, connect = TRUE)
```

## Arguments

- name:

  Your name

- likes:

  Your likes

- learn:

  What you're learning

- work:

  What you're currently working on

- collab:

  What you'd like to collaborate on

- connect:

  logical (TRUE/FALSE)

## Value

printed intro

## Examples

``` r
who_am_i(name = "Martin",
likes = "#rstats and data visualization.",
learn = "shiny app development, JavaScript, and Bayesian statistics.",
work = "R package development tools.",
collab = "#rstats packages for data science.")
#> 👋 Hi, my name is Martin.
#> 👀 I like #rstats and data visualization.
#> 🌱 I'm learning about shiny app development, JavaScript, and Bayesian
#> statistics.
#> 📦 I'm currently working on R package development tools.
#> 💞 I'd love to collaborate on #rstats packages for data science.
#> 📫 Want to connect? Use the badges below...
```
