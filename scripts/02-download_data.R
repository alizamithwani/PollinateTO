#### Preamble ####
# Purpose: Downloads and saves the data directly from Open Data Toronto
# Author: Aliza Abbas Mithwani
# Date: 3 December 2024
# Contact: aliza.mithwani@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse` and `opendatatoronto` packages must be installed and loaded
# Any other information needed? Make sure you are in the `PollinateTO` rproj

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