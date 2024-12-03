#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(522)


#### Simulate data ####

#### Define years of funding ####
years_of_funding <- c(2020,2021,2022,2023)

#### Garden types list ####
garden_types <- c(
  "Multiple Front Yard Gardens",
  "Communal Garden",
  "School Learning Garden",
  "City Park",
  "Spiritual Centre Garden",
  "Boulevard Garden, Rain Garden",
  "Multi-Residential Garden",
  "Spiritual Centre Garden, Rain Garden",
  "Boulevard Garden",
  "City Park, Rain Garden",
  "Multiple Boulevard Gardens",
  "Multiple Property Garden"
)

nia_or_en_options <- c("NIA","EN","None")

ward_names <- c("Davenport","Scarborough-Agincourt","Toronto-Danforth",
                "Etobicoke Centre","Scarborough Southwest",
                "Etobicoke-Lakeshore","University-Rosedale","Toronto-St. Paul's",
                "Toronto Centre","Don Valley East","Eglinton-Lawrence","Parkdale-High Park",
                "Beaches-East York","Scarborough-Rouge Park","Humber River-Black Creek",
                "Spadina-Fort York","York Centre","Etobicoke North","Scarborough-Guildwood",
                "York South-Weston","Willowdale","Don Valley West",
                "Don Valley North","Scarborough Centre")

is_indigenous_garden_options <- c(0,1)

# Create a dataset by randomly assigning values to variables for each id
simulated_data <- tibble(
  id = paste(1:149),
  year_funded = sample(
    years_of_funding,
    size = 149,
    replace = TRUE
  ),
  garden_type = sample(
    garden_types,
    size = 149,
    replace = TRUE
  ),
  nia_or_en = sample(
    nia_or_en_options,
    size = 149,
    replace = TRUE
  ),
  ward_name = sample(
    ward_names,
    size = 149,
    replace = TRUE
  ),
  is_indigenous_garden = sample(
    is_indigenous_garden_options,
    size=149,
    replace = TRUE
  ),
  number_of_gardens = sample(1:22, 1, replace = TRUE
  ),
  estimated_garden_size = runif(1, min = 4, max = 2023)
)


#### Save data ####
write_csv(simulated_data, "./data/00-simulated_data/simulated_data.csv")
