
library(fs)
library(tidyverse)
library(magrittr)
library(sf)
library(sp)
library(feather)

df_tidy <- read_feather(path = "out/constituency_data.feather")

# target post code sectors
target_constituencies <- df_tidy %>%
  filter(turnout < 60 & women_age30to45 > .13) %>%
  select(name_constituency, postcode_sectors) %>%
  mutate(pclist = str_split(postcode_sectors, ",")) %>%
  select(-postcode_sectors)
# random control group
postcode_sector_lookup <- read_feather("data/postcode_sector_lookup.feather")
set.seed(3)
out_cntrl <- postcode_sector_lookup$postcode_sectors %>%
  str_split(",") %>%
  unlist() %>%
  sample(size = 100)

# write output
file_delete("out/experiment_postcodes.txt")
file_create("out/experiment_postcodes.txt")
for (const in target_constituencies[["name_constituency"]]) {
  x <- target_constituencies %>% 
    filter(name_constituency == const) %>%
    pluck("pclist") %>%
    unlist() %>%
    str_replace("^\\s", "")
  write_lines(
    x = const,
    path = "out/experiment_postcodes.txt",
    append = TRUE)
  write_lines(
    x = x, 
    path = "out/experiment_postcodes.txt",
    append = TRUE)
}
# add control group to output
write_lines(
  x = c("Control Group", out_cntrl), 
  path = "out/experiment_postcodes.txt",
  append = TRUE)

