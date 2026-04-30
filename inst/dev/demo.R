## collect_git_commits.R -------
source("R/collect_git_commits.R")

### collect  -----
commits <- collect_git_commits(
  user   = "mjfrigaard",
  emails = c("mjfrigaard@pm.me", "mjfrigaard@gmail.com")
)

## spiral_points_plot.R -------
source("R/spiral_points_plot.R")

### single repo  -----
spiral_points_plot(commits, repo = "shiny-app-pkgs")

### handful of repos  -----
spiral_points_plot(commits, repo = c("shiny-app-pkgs", "shinypak", "ttdviewer"))

### everything, 2023 onward  -----
spiral_points_plot(commits, date_begin = "2023-01-01")

## spiral_heatmap_plot -------
source("R/spiral_heatmap_plot.R")

### single repo  -----
spiral_heatmap_plot(commits, repo = "shiny-app-pkgs")

### handful of repos  -----
spiral_heatmap_plot(commits, repo = c("shiny-app-pkgs", "shinypak", "ttdviewer"))

### everything, 2023 onward
spiral_heatmap_plot(commits, date_begin = "2023-01-01")

## spiral_horizon_plot -----
source("R/spiral_horizon_plot.R")

### single repo  -----
spiral_horizon_plot(commits, repo = "shiny-app-pkgs")

### handful of repos  -----
spiral_horizon_plot(commits, repo = c("shiny-app-pkgs", "shinypak", "ttdviewer"))

### everything, 2023 onward  -----
spiral_horizon_plot(commits, date_begin = "2023-01-01")

## calendar_heatmap_plot -----
source("R/calendar_heatmap_plot.R")

### single repo  -----
calendar_heatmap_plot(commits, repo = "shiny-app-pkgs")

### handful of repos  -----
calendar_heatmap_plot(commits, repo = c("shiny-app-pkgs", "shinypak", "ttdviewer"))

### everything, 2023 onward  -----
calendar_heatmap_plot(commits, date_begin = "2023-01-01")

## punchcard_plot ----
source("R/punchcard_plot.R")

### single repo  -----
punchcard_plot(commits, repo = "shiny-app-pkgs")

### handful of repos  -----
punchcard_plot(commits, repo = c("shiny-app-pkgs", "shinypak", "ttdviewer"))

### everything, 2023 onward  -----
punchcard_plot(commits, date_begin = "2023-01-01")

## cumulative_line_plot.R ----
source("R/cumulative_line_plot.R")

### single repo  -----
cumulative_line_plot(
  commits, 
  repo = "shiny-app-pkgs")

### handful of repos  -----
cumulative_line_plot(
  commits, 
  repo = c("shiny-app-pkgs", "shinypak", "ttdviewer")
  )

### everything, 2023 onward  -----
cumulative_line_plot(commits, top_n = 10)

## scatter_density_plot.R ------
source("R/scatter_density_plot.R")

# ggplot, date × time, single repo ------
scatter_density_plot(commits, 
  repo = "shiny-app-pkgs")

# density (marginal distributions) -----
scatter_density_plot(
  commits, 
  date_begin = "2024-01-01", 
  plot_type = "density")

# interactive plotly, weekday × time across top 15 repos ----
scatter_density_plot(commits, 
  x = "weekday", 
  y = "time", 
  plot_type = "plotly")
