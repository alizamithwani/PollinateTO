#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
package <- show_package("pollinateto-primary-project-garden-locations")
resources <- list_package_resources("pollinateto-primary-project-garden-locations")
csv_resource <- resources[resources$format == "CSV", ]
first_csv_resource <- csv_resource[1, ]
csv_id <- first_csv_resource$id
pollinateto_data <- get_resource(csv_id) 

#### Save data ####
write_csv(pollinateto_data, "./data/01-raw_data/PT_raw_data.csv")