
library(fs)
library(tidyverse)
library(magrittr)
library(sf)
library(sp)
library(feather)

x <- rbind(
  c("Control Group",  3354,   14.71),
  c("Kensington",       64,       0),
  c("Barking",          51,       0),
  c("Slough",          204,   50.00),
  c("Hackney North",   439,   22.22),
  c("Hackney South",   558,    7.69)) %>%
  set_colnames(
    c("name_constituency",
      "count_impressions",
      "perc_conversions")) %>%
  as_tibble() %>%
  mutate(
    count_impressions = as.numeric(count_impressions),
    perc_conversions = as.numeric(perc_conversions) / 100)

x %>%
  transmute(
    name_constituency,
    count_converters = count_impressions * perc_conversions,
    count_nonconverters = count_impressions * (1 - perc_conversions))



