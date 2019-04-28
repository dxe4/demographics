library(tidyverse)

df.ward <- read_csv("data/england+wales_ward_pop.csv")

cleaned <- df.ward %>%
  select(-`All Ages`)
names(cleaned)[1:4] <- c("ward", "name", "la", "gen")
cleaned <- cleaned %>% gather(age, population, -name, -ward, -la, -gen) %>%
  as_tibble
cleaned$age[cleaned$age=="90+"] <- 90
cleaned$age <- cleaned$age %>% as.numeric

# 30-45 women ----

cleaned$is.35w <- ((cleaned$age > 29) &
  (cleaned$age < 46) & (cleaned$gen == "F"))
df.f <- cleaned %>% group_by(ward, is.35w) %>%
  summarise(pop = sum(population)) %>%
  spread(is.35w, pop) %>%
  mutate(target.pc = `TRUE` / (`TRUE`+`FALSE`))
df.f$pop <- df.f$`FALSE`+df.f$`TRUE`
df.f <- df.f[c(1,4,5)]
names(df.f)[2] <- "30-45w"
df.f %>% write_csv("data/ward_pop_f30to45.csv")

# 16-23s ----

df.youth <- cleaned %>% mutate(is.youth = (age>15 & age<24))
df.youth <- df.youth %>% group_by(ward, is.youth) %>%
  summarise(pop = sum(population)) %>%
  spread(is.youth, pop) %>%
  mutate(youth = `TRUE` / (`TRUE`+`FALSE`))
names(df.youth)[2] <- "pop"
df.youth$pop <- df.youth[[2]]+df.youth[[3]]
df.youth <- df.youth[c(1,4,2)]
df.youth %>% write_csv("data/ward_pop_16to23.csv")

# Scotland ----

df.scot <- read_csv("data/scotland_ward_pop.csv") %>%
  filter(SEX != "Persons") %>%
  select(-TOTAL) %>%
  gather(age, population, -SEX, -ElectoralWard2016Code, -ElectoralWard2016Name) %>%
  as_tibble
df.scot$age <- as.numeric(df.scot$age)
names(df.scot)[1] <- "gen"
df.scot$is.30w <- ((df.scot$age > 29) &
                     (df.scot$age < 46) & (df.scot$gen == "F"))
df.scot$is.youth <- (df.scot$age>15 & df.scot$age<24)
names(df.scot)[2:3] <- c("ward", "name")

# 30w
df.f.scot <- df.scot %>% group_by(ward, name, is.30w) %>%
  summarise(pop = sum(population)) %>%
  spread(is.30w, pop)
names(df.f.scot)[3:4] <- c("pop", "30-34w")
df.f.scot$pop <- df.f.scot$pop + df.f.scot[[4]]
df.f.scot$`30-34w` <- df.f.scot$`30-34w` / df.f.scot$pop
df.f.scot <- df.f.scot[c(1,4,3)]
df.f.scot %>% write_csv("data/ward_pop_f30to45_scot.csv")

# youth
df.youth.scot <- df.scot %>% group_by(ward, name, is.youth) %>%
  summarise(pop = sum(population)) %>%
  spread(is.youth, pop)
names(df.youth.scot)[3:4] <- c("pop", "youth")
df.youth.scot$pop <- df.youth.scot$pop + df.youth.scot[[4]]
df.youth.scot$youth <- df.youth.scot$youth / df.youth.scot$pop
df.youth.scot <- df.youth.scot[c(1,4,3)]
df.youth.scot %>% write_csv("data/ward_pop_16to23_scot.csv")

# EU Nationals