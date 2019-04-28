
library(fs)
library(tidyverse)
library(magrittr)
library(sf)
library(sp)
library(feather)
library(rmapshaper)

# load data
gb_wards <- sf::read_sf("data/GB_wards_2017/GB_wards_2017.shp") %>%
  transmute(
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
    perc_turnout = `Turnout %`) %>%
  distinct()

constituency_lookup <- "data/GB_wards_2017/constituency_lookup.csv" %>%
  read_csv() %>%
  transmute(
    code_ward = as.character(WD17CD),
    name_ward = WD17NM,
    code_constituency = PCON17CD,
    name_constituency = PCON17NM) %>%
  distinct()

ward_pop <- "data/ward_pop_f30to45.csv" %>%
  read_csv() %>%
  transmute(
    code_ward = as.character(ward),
    women_age30to45 = `30-45w`,
    population = pop) %>%
  distinct()

postcode_sector_lookup <- "data/postcode_sector_lookup.csv" %>%
  read_csv() %>%
  transmute(
    code_ward = as.character(`Ward Code`),
    code_constituency = as.character(`Parliamentary Constituency Code`),
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
    postcode_sectors = str_c(postcode_sector, collapse = ",")) %>%
  distinct()
write_feather(postcode_sector_lookup, "data/postcode_sector_lookup.feather")


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
df_constituencies <- df_joined %>%
  group_by(code_constituency) %>%
  summarise(
    name_constituency = first(name_constituency), # TODO!
    tot_pop = sum(population),
    tot_electorate = sum(unique(count_electorate)),
    turnout = sum(population * perc_turnout) / tot_pop,
    women_age30to45 = (sum(population * women_age30to45) / tot_pop) * 100,
    postcode_sectors = str_c(postcode_sectors, collapse = ", "),
    do_union = TRUE) %>%
  # simplify geometries
  ms_simplify(keep = 0.01)


# adding information on age and eu nationals
postcode_age <- "data/AGESps_sector_out.csv" %>%
  read_csv() %>%
  mutate(postcode_sectors = `posstcode sector`) %>%
  select(postcode_sectors, contains("%"))

postcode_eu_nationals <- "data/PASSPORTps_sector_out.csv" %>%
  read_csv() %>%
  transmute(
    postcode_sectors = `postcode sector`,
    perc_eu = `%`)

# postcode level data
df_postcodes <- df_constituencies %>%
  as_tibble() %>%
  select(postcode_sectors, code_constituency, turnout, women_age30to45) %>%
  separate_rows(postcode_sectors, sep = ",") %>%
  mutate(postcode_sectors = str_replace(postcode_sectors, "^\\s+", "")) %>%
  mutate(postcode_sectors = str_replace(postcode_sectors, "\\s+$", "")) %>%
  distinct() %>%
  left_join(postcode_eu_nationals, by = "postcode_sectors") %>%
  left_join(postcode_age, by = "postcode_sectors")

write_csv(df_postcodes, "out/postcode_sector_level_data.csv")
write_feather(x = df_postcodes, path = "out/postcode_sector_data.feather")

# join back to constituencies
df_constituencies <- df_constituencies %>%
  left_join(
    df_postcodes %>%
      select(-postcode_sectors, -turnout, -women_age30to45) %>%
      group_by(code_constituency) %>%
      summarise_all(mean, na.rm = TRUE),
    by = "code_constituency")

write_rds(df_constituencies, path = "out/constituency_data.rds")
df_constituencies %>%
  as_tibble() %>%
  select(-geometry) %>%
  write_feather(path = "out/constituency_data.feather")


