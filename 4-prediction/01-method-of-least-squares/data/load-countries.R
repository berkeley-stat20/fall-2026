# Built by Everett Wetchler + Claude
# Loads the happiness data used in tutorial-alt.qmd as a data frame called `countries`:
# one row per country in 2025, with gdp in thousands of dollars.
# (The same prep as the setup chunk at the top of notes-alt.qmd.)
library(dplyr)

raw <- read.csv("data/gdp-vs-happiness.csv", check.names = FALSE)

# The continent is only filled in on some rows, so look it up by country code
continent_lookup <- raw |>
  filter(`World region according to OWID` != "") |>
  distinct(Code, continent = `World region according to OWID`)

# Codes starting with OWID are regional aggregates, not countries
countries <- raw |>
  filter(
    Year == 2025,
    !is.na(`Life satisfaction`), !is.na(`GDP per capita`),
    Code != "", !startsWith(Code, "OWID")
  ) |>
  left_join(continent_lookup, by = "Code") |>
  transmute(country = Entity, continent,
            gdp = `GDP per capita` / 1000, happiness = `Life satisfaction`) |>
  as_tibble()

rm(raw, continent_lookup)
