#### Preamble ####
# Purpose: Tests the structure and validity of the PollinateTO Primary Project Garden Locations simulated dataset
# Author: Aliza Abbas Mithwani
# Date: 3 December 2024
# Contact: aliza.mithwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `PollinateTO` rproj


#### Workspace setup ####
library(tidyverse)

analysis_data_simulated <- read_csv("./data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data_simulated")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 149 rows
if (nrow(analysis_data_simulated) == 149) {
  message("Test Passed: The dataset has 149 rows.")
} else {
  stop("Test Failed: The dataset does not have 149 rows.")
}

# Check if the dataset has 3 columns
if (ncol(analysis_data_simulated) == 8) {
  message("Test Passed: The dataset has 8 columns.")
} else {
  stop("Test Failed: The dataset does not have 8 columns.")
}

# Check if all values in the 'id' column are unique
if (n_distinct(analysis_data_simulated$id) == nrow(analysis_data_simulated)) {
  message("Test Passed: All values in 'id' are unique.")
} else {
  stop("Test Failed: The 'id' column contains duplicate values.")
}

# Check if the 'garden_type' column contains only valid garden types
valid_gardentype <- c("Multiple Front Yard Gardens",
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
                    "Multiple Property Garden")

if (all(analysis_data_simulated$garden_type %in% valid_gardentype)) {
  message("Test Passed: The 'garden_type' column contains only valid garden types.")
} else {
  stop("Test Failed: The 'garden_type' column contains invalid garden types.")
}

# Check if the 'ward_name' column contains only valid ward names
valid_wards <- c("Davenport","Scarborough-Agincourt","Toronto-Danforth",
                   "Etobicoke Centre","Scarborough Southwest",
                   "Etobicoke-Lakeshore","University-Rosedale","Toronto-St. Paul's",
                   "Toronto Centre","Don Valley East","Eglinton-Lawrence","Parkdale-High Park",
                   "Beaches-East York","Scarborough-Rouge Park","Humber River-Black Creek",
                   "Spadina-Fort York","York Centre","Etobicoke North","Scarborough-Guildwood",
                   "York South-Weston","Willowdale","Don Valley West",
                   "Don Valley North","Scarborough Centre")

if (all(analysis_data_simulated$ward_name %in% valid_wards)) {
  message("Test Passed: The 'ward_name' column contains only valid ward names.")
} else {
  stop("Test Failed: The 'ward_name' column contains invalid ward names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data_simulated))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Test that all 'garden_type', 'nia_or_en', and 'ward_name' columns are strings
if (all(is.character(analysis_data_simulated$garden_type) 
        & is.character(analysis_data_simulated$nia_or_en) 
        & is.character(analysis_data_simulated$ward_name))) {
  message("Test Passed: The 'garden_type', 'nia_or_en' and 'ward_name' columns are strings.")
} else {
  stop("Test Failed: There are erroneous non-string values")
}

# Check if there are no empty strings in garden_type','nia_or_en, and 'ward_name' columns
if (all(analysis_data_simulated$garden_type != "" & 
        analysis_data_simulated$nia_or_en != "" & analysis_data_simulated$ward_name != "") == TRUE) {
  message("Test Passed: There are no empty strings in garden_type', 'nia_or_en' and ward_name'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'garden_type' column has at least two unique values
if (n_distinct(analysis_data_simulated$garden_type) >= 2) {
  message("Test Passed: The 'garden_type' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'garden_type' column contains less than two unique values.")
}

# Check if the 'ward_name' column has at least two unique values
if (n_distinct(analysis_data_simulated$ward_name) >= 2) {
  message("Test Passed: The 'ward_name' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'ward_name' column contains less than two unique values.")
}

# Test that data is strictly from 2020 to 2023
if (all(analysis_data_simulated$year_funded %in% 2020:2023)) {
  message("Test Passed: The 'year_funded' column contains only years from 2020 to 2023")
} else {
  stop("Test Failed: The 'year_funded' column contains irrelevant years.")
}
  
# Test that the 'year_funded', 'number_of_gardens', 'estimated_garden_size', and 'is_indigenous_garden' columns are numeric
if (all(is.numeric(analysis_data_simulated$year_funded) & is.numeric(analysis_data_simulated$number_of_gardens) 
        & is.numeric(analysis_data_simulated$estimated_garden_size) 
        & is.numeric(analysis_data_simulated$is_indigenous_garden))) {
  message("Test Passed: The 'year_funded', 'number_of_gardens', 'estimated_garden_size', and 'is_indigenous_garden' columns are numeric")
} else {
  stop("Test Failed: There are non-numerical values in one or more numerical columns.")
}

# Test that the 'year_funded', 'number_of_gardens', and 'estimated_garden_size' columns are positive
if (all(analysis_data_simulated$year_funded >= 0 & analysis_data_simulated$number_of_gardens >= 0 
        & analysis_data_simulated$estimated_garden_size >= 0) == TRUE) {
  message("Test Passed: The 'year_funded', 'number_of_gardens', 'estimated_garden_size', and 'is_indigenous_garden' columns are positive")
} else {
  stop("Test Failed: There are erroneous non-positive values in one or more columns.")
}

