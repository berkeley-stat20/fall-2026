# Built by Everett Wetchler + Claude
# Loads the happiness data used in tutorial-alt.qmd as a data frame called `countries`:
# one row per country in 2025 (the 131 with data in every year 2022-2025),
# with gdp in thousands of dollars.
# (The same prep as the setup chunk at the top of notes-alt.qmd.)
library(dplyr)

raw <- read.csv("data/gdp-vs-happiness.csv", check.names = FALSE)

# The continent is only filled in on some rows, so look it up by country code
continent_lookup <- raw |>
  filter(`World region according to OWID` != "") |>
  distinct(Code, continent = `World region according to OWID`)

# Codes starting with OWID are regional aggregates, not countries. Like the notes, keep
# only countries with data in every year from 2022 to 2025, then use 2025.
has_data <- raw |>
  filter(!is.na(`Life satisfaction`), !is.na(`GDP per capita`),
         Code != "", !startsWith(Code, "OWID"))
all_four_years <- has_data |>
  filter(Year %in% 2022:2025) |>
  group_by(Code) |>
  filter(n_distinct(Year) == 4) |>
  ungroup()
countries <- all_four_years |>
  filter(Year == 2025) |>
  left_join(continent_lookup, by = "Code") |>
  transmute(country = Entity, continent,
            gdp = `GDP per capita` / 1000, happiness = `Life satisfaction`) |>
  as_tibble()

rm(raw, continent_lookup, has_data, all_four_years)
