library(tidyverse)
library(rvest)

food_consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-18/food_consumption.csv')

url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"

population <- 
  url %>%
  xml2::read_html() %>%
  html_table()

population <- 
  population[[1]]

population_clean <- # have to do some manual cleaning
  population %>%
  janitor::clean_names() %>%
  mutate(
    country = case_when(
      country_or_dependent_territory == "United States[c]" ~ "USA",
      country_or_dependent_territory == "Bermuda (UK)" ~ "Bermuda",
      country_or_dependent_territory == "France[e]" ~ "France",
      country_or_dependent_territory == "Hong Kong (China)" ~ "Hong Kong SAR. China",
      country_or_dependent_territory == "French Polynesia (France)" ~ "French Polynesia",
      country_or_dependent_territory == "United Kingdom[f]" ~ "United Kingdom",
      country_or_dependent_territory == "Russia[d]" ~ "Russia",
      country_or_dependent_territory == "New Caledonia (France)" ~ "New Caledonia",
      country_or_dependent_territory == "Serbia[l]" ~ "Serbia",
      country_or_dependent_territory == "Ukraine[h]" ~ "Ukraine",
      country_or_dependent_territory == "North Macedonia" ~ "Macedonia",
      country_or_dependent_territory == "Morocco[i]" ~ "Morocco",
      country_or_dependent_territory == "Georgia[m]" ~ "Georgia",
      country_or_dependent_territory == "China[b]" ~ "China",
      country_or_dependent_territory == "Taiwan[j]" ~ "Taiwan. ROC",
      country_or_dependent_territory == "Tanzania[g]" ~ "Tanzania",
      TRUE ~ country_or_dependent_territory
    ),
    population_num = as.numeric(str_replace_all(population, ",", ""))
  )

food_country_pop <- # only Swaziland missing
  left_join(food_consumption, population_clean, by = c("country" = "country")) %>% 
  mutate(tot_co2_emissions = co2_emmission * population_num)

# seeing who top offender is
# us

food_country_pop %>% 
  group_by(country) %>% 
  summarise(sum(tot_co2_emissions)) %>% 
  top_n(5)

# create a "total emissions" number

total_emissions <-
  food_country_pop %>% 
  summarise(sum(tot_co2_emissions, na.rm = TRUE)) %>% 
  mutate(food_category = "Total") %>% 
  rename(tot_co2_emissions = `sum(tot_co2_emissions, na.rm = TRUE)`)

# emissions by food group

food_group_emissions <-
  food_country_pop %>% 
  group_by(food_category) %>% 
  summarise(sum(tot_co2_emissions, na.rm = TRUE)) %>% 
  rename(tot_co2_emissions = `sum(tot_co2_emissions, na.rm = TRUE)`)

emissions_all <-
  bind_rows(total_emissions,
            food_group_emissions %>% select(food_category, tot_co2_emissions))

