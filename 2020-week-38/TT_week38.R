rm(list = ls())

library(tidyverse)
library(plotly)

kids <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-15/kids.csv')

kids <- kids %>%
  subset(variable == "PK12ed")

kids$code <- state.abb[match(kids$state, state.name)]
kids$code[9] <- "DC"

kids$inf_adj_perchild <- kids$inf_adj_perchild*1000
kids$inf_adj_perchild <- round(kids$inf_adj_perchild, 2)

g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

f <- list(
  size = 14
)

fig <- plot_geo(kids, locationmode = "USA-states") %>%
  add_trace(z = ~inf_adj_perchild, color = ~inf_adj_perchild, colorscale = 'Viridis', locations = ~code, frame = ~year, ids = ~code, text = ~paste0(state, ",", year, "<br>", "Spending per pupil: $", inf_adj_perchild), hoverinfo = "text") %>%
  colorbar(tickprefix = "$") %>%
  layout(geo = g, title = ~paste0("<b>Public spending on elementary and secondary education (1997 - 2016)</b>", "<br>", "(Values adjusted for inflation, in 2016 dollars)"))
  

fig
