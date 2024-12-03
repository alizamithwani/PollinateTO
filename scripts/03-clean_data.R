#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

## DELETE COLUMNS IM NOT USING AND RELEVANT CLEANING

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
  # ensure the year funded, number of gardens, estimated garden size are numbers
  mutate(
    year_funded = as.numeric(year_funded),
    number_of_gardens = as.numeric(number_of_gardens),
    estimated_garden_size = as.numeric(estimated_garden_size),
    # ensure the neighborhood number, ward_number, id, nia_or_en, group name, project name, garden type, location name, garden address, postal code, ward name and geometry are strings
    neighbourhood_number = as.character(neighbourhood_number),
    ward_number = as.character(ward_number),
    id = as.character(id),
    nia_or_en = as.character(nia_or_en),
    group_name = as.character(group_name),
    project_name = as.character(project_name),
    garden_type = as.character(garden_type),
    primary_location_name = as.character(primary_location_name),
    primary_garden_address = as.character(primary_garden_address),
    postal_code = as.character(postal_code),
    ward_name = as.character(ward_name),
    geometry = as.character(geometry),
    # Convert the is_indigenous_garden column to binary column where 1 means that the project is indigenous led
    is_indigenous_garden = if_else(is_indigenous_garden == "Y", 1, 0)
  ) |>
  #drop any rows with missing/NA values
  tidyr::drop_na()

#### Save data ####
write_parquet(cleaned_data, "./data/02-analysis_data/PT_analysis_data.parquet")
