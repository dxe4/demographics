
library(fs)
library(tidyverse)
library(sf)
library(sp)

# load data
gb_wards <- sf::read_sf("data/GB_wards_2017/GB_wards_2017.shp") %>%
  as_tibble() %>%
  select(-geometry) %>%
  transform(
    code_ward = as.character(wd17cd),
    code_name = wd17nm,
    lat = lat,
    long = long,
    total_area = st_areasha)

constituency_turnout <- "data/constituency_turnout.csv" %>%
  read_csv() %>%
  transmute(
    name_constituency = Constituency,
    count_electorate = Electorate,
    perc_turnout = `Turnout %`)

constituency_lookup <- "data/GB_wards_2017/constituency_lookup.csv" %>%
  read_csv() %>%
  transform(
    code_ward = WD17CD,
    name_ward = WD17NM,
    code_constituency = PCON17CD,
    name_constituency = PCON17NM) %>%
  distinct()

ward_pop <- "data/ward_pop_f30to45.csv" %>%
  read_csv() %>%
  transform(
    code_ward = ward,
    women_age30to45 = `30-45w`,
    population = pop) %>%
  unique()

postcode_sector_lookup <- "data/postcode_sector_lookup.csv" %>%
  read_csv() %>%
  transform(
    code_ward = `Ward Code`,
    code_constituency = `Parliamentary Constituency Code`,
    name_constituency = `Parliamentary Constituency Name`,
    code_euregion = `European Electoral Region Code`,
    name_euregion = `European Electoral Region Name`,
    postcode_sector = postcode_sector) %>%
  distinct() %>%
  group_by(code_ward) %>%
  summarise(
    code_constituency_ps = first(code_constituency), #TODO!
    name_constituency_ps = first(name_constituency),
    code_euregion = first(code_euregion),
    name_euregion = first(name_euregion),
    postcode_sectors = str_c(postcode_sector, collapse = ","))


df_joined <- gb_wards %>%
  # join constituency
  left_join(
    constituency_lookup,
    by = "code_ward") %>%
  # join total population and female 30-45 segment info
  left_join(
    ward_pop,
    by = "code_ward") %>%
  left_join(
    postcode_sector_lookup,
    by = "code_ward") %>%
  left_join(
    constituency_turnout,
    by = "name_constituency")


# top ten constituencies with highest % with women 30-45
df_tidy <- df_joined %>%
  group_by(code_constituency) %>%
  summarise(
    name = first(name_constituency), # TODO!
    tot_pop = sum(pop),
    tot_electorate = sum(unique(count_electorate)),
    women_age30to45 = sum(pop * women_age30to45) / tot_pop,
    turnout = sum(pop * perc_turnout) / tot_pop
  ) %>%
  arrange(desc(women_age30to45))


ggplot(df_tidy, aes(
  x = women_age30to45, 
  y = turnout, 
  size = tot_electorate)) +
  geom_point(alpha = .5)


