#### Preamble ####
# Purpose: Cleans the raw data directly from Open Data Toronto's website
# Author: Aliza Abbas Mithwani
# Date: 3 December 2024
# Contact: aliza.mithwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse`, `dplyr`, and `arrow` packages must be installed and loaded
  # - 02-download_data.R must have been run
# Any other information needed? Make sure you are in the `PollinateTO` rproj

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)

#### Clean data ####
PT_raw_data <- read_csv("./data/01-raw_data/PT_raw_data.csv")

cleaned_data <-
  PT_raw_data |>
  janitor::clean_names() |>
  # Remove the redundant 'x_id' column as it is same as 'id' column
  select(-x_id) |>
  # Remove columns that have no data i.e. all values are "None"
  select (-description) |>
  select (-image_name) |>
  select (-image_alt_text) |>
  # Remove unused columns
  select (-group_name) |>
  select (-project_name) |>
  select (-neighbourhood_number) |>
  select (-primary_location_name) |>
  select (-primary_garden_address) |>
  select (-postal_code) |>
  select (-geometry) |>
  select (-ward_number) |>
  # ensure the year funded, number of gardens, estimated garden size are numbers
  mutate(
    year_funded = as.numeric(year_funded),
    number_of_gardens = as.numeric(number_of_gardens),
    estimated_garden_size = as.numeric(estimated_garden_size),
    # ensure the nia_or_en, garden type, and ward name are strings
    nia_or_en = as.character(nia_or_en),
    garden_type = as.character(garden_type),
    ward_name = as.character(ward_name),
    # Convert the is_indigenous_garden column to binary column where 1 means that the project is indigenous led
    is_indigenous_garden = if_else(is_indigenous_garden == "Y", 1, 0),
    ward_name = if_else(ward_name == "Etobicoke-North", "Etobicoke North", ward_name)
  ) |>
  #drop any rows with missing/NA values
  tidyr::drop_na()

#### Save data ####
write_parquet(cleaned_data, "./data/02-analysis_data/PT_analysis_data.parquet")
