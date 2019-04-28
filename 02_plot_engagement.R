
library(fs)
library(tidyverse)
library(magrittr)
library(sf)
library(sp)
library(feather)

df_tidy <- read_feather(path = "data/tidy_data.feather")

ggp <- ggplot(df_tidy, aes(
  x = women_age30to45, 
  y = turnout, 
  size = tot_electorate)) +
  geom_point(alpha = .5) +
  theme_minimal() +
  xlab("Percentage of Women aged 30 to 45") +
  ylab("Election turnout in the 2015 election") +
  ggtitle(
    label = "Turnout vs Target Female Group in English and Welsh Constituencies",
    subtitle = "Most promising targets are constituencies the bottom right") +
  guides(size = guide_legend(
    title = "Size of electorate \nin constituency", title.position = "top"))

ggsave(filename = "plot_women_vs_turnout.png", plot = ggp)


