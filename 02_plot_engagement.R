
library(fs)
library(tidyverse)
library(magrittr)
library(sf)
library(sp)
library(feather)
library(gridExtra)

df_constituencies <- read_feather(path = "out/constituency_data.feather")

# plot maps

ggp1 <- df_constituencies %>%
  transmute(tot_pop = tot_pop / 10000) %>%
  ggplot() +
  geom_sf(aes(fill = tot_pop), colour = FALSE) +
  scale_fill_continuous(type = "viridis") +
  ggtitle("Total population (in 10K)") +
  theme(
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_blank())

ggp2 <- df_constituencies %>%
  select(turnout) %>%
  mutate(turnout = case_when(
    turnout == 0.0 ~ NA_real_,
    TRUE ~ turnout)) %>%
  ggplot() +
  geom_sf(aes(fill = turnout), colour = FALSE) +
  scale_fill_continuous(type = "viridis") +
  ggtitle("Turnout in 2015 election") +
  theme(
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_blank())

ggp3 <- df_constituencies %>%
  transmute(women_age30to45 = women_age30to45 * 100) %>%
  mutate(women_age30to45 = case_when(
    women_age30to45 == 0.0 ~ NA_real_,
    TRUE ~ women_age30to45)) %>%
  ggplot() +
  geom_sf(aes(fill = women_age30to45), colour = FALSE) +
  scale_fill_continuous(type = "viridis") +
  ggtitle("Percent women aged 30-45") +
  theme(
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_blank())

ggp4 <- df_constituencies %>%
  select(perc_eu) %>%
  mutate(perc_eu = case_when(
    perc_eu == 0.0 ~ NA_real_,
    TRUE ~ perc_eu)) %>%
  ggplot() +
  geom_sf(aes(fill = perc_eu), colour = FALSE) +
  scale_fill_continuous(type = "viridis") +
  ggtitle("Percent EU citizens") +
  theme(
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_blank())

grid.arrange(ggp1, ggp2, ggp3, ggp4, ncol = 4) %>%
  ggsave(width = 40, height = 14, units = "cm", filename = "out/maps.png")


# plot engagement

ggp5 <- df_constituencies %>%
  filter(women_age30to45 > 0 & tot_electorate > 0) %>%
  ggplot(aes(
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

ggsave(filename = "out/plot_women_vs_turnout.png", plot = ggp5)


ggp6 <- df_constituencies %>%
  filter(perc_eu > 0 & tot_electorate > 0 & turnout > 0) %>%
  ggplot(aes(
    x = perc_eu, 
    y = turnout, 
    size = tot_electorate)) +
  geom_point(alpha = .5) +
  theme_minimal() +
  xlab("Percentage of EU citizens") +
  ylab("Election turnout in the 2015 election") +
  ggtitle(
    label = "Turnout vs EU citizenship",
    subtitle = "Most promising targets are constituencies the bottom right") +
  guides(size = guide_legend(
    title = "Size of electorate \nin constituency", title.position = "top"))

ggsave(filename = "out/plot_eucitizen_vs_turnout.png", plot = ggp6)



