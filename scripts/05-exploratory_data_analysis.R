#### Preamble ####
# Purpose: Examine trends, distributions, and relationships within the PollinateTO dataset
# Author: Aliza Abbas Mithwani
# Date: 3 December 2024
# Contact: aliza.mithwani@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # - The `tidyverse`, `arrow`, `ggplot2`, `knitr`, and `dplyr` packages must be installed and loaded
  # - 02-download_data.R and 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `PollinateTO` rproj

#### Workspace setup ####
library(tidyverse)
library(ggplot2)
library(dplyr)
library(knitr)
library(arrow)

#### Read data ####
PT_analysis_data <- read_parquet("./data/02-analysis_data/PT_analysis_data.parquet")

# Summarize the data by year to get the total number of gardens and average garden size per year
PT_summary <- PT_analysis_data %>%
  group_by(year_funded) %>%
  summarise(
    total_gardens = sum(number_of_gardens, na.rm = TRUE), # Summing number of gardens per year
    avg_garden_size = mean(estimated_garden_size, na.rm = TRUE) # Calculating average garden size
  )

# Create the line chart with two y-axes (total gardens and average size)
ggplot(PT_summary, aes(x = year_funded)) +
  geom_line(aes(y = total_gardens), color = "blue", linewidth = 1.2, linetype = "solid") + 
  geom_line(aes(y = avg_garden_size), color = "red", linewidth = 1.2, linetype = "dashed") +
  scale_y_continuous(
    name = "Total Number of Gardens", 
    sec.axis = sec_axis(~., name = "Average Garden Size (Estimated)")
  ) +
  labs(
    title = "Trend of Garden Size and Number Over Time",
    x = "Year Funded",
    y = "Total Number of Gardens"
  ) +
  theme_minimal() +
  theme(
    axis.title.y.right = element_text(color = "red"),
    axis.text.y.right = element_text(color = "red")
  )

# Summarize the data to get the count of garden types by year
PT_summary <- PT_analysis_data %>%
  group_by(year_funded, garden_type) %>%
  summarise(
    garden_count = n(), # Count the number of occurrences for each garden type per year
    .groups = "drop"
  )

# Create the bar chart
ggplot(PT_summary, aes(x = year_funded, y = garden_count, fill = garden_type)) +
  geom_bar(stat = "identity", position = "stack") + # Stacked bar chart
  scale_fill_brewer(palette = "Set3") + # Use a color palette for clarity
  labs(
    title = "Distribution of Garden Types Funded Over Time",
    x = "Year Funded",
    y = "Number of Gardens",
    fill = "Garden Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(hjust = 1) # Rotate x-axis labels for readability
  )

# Filter for Indigenous-Led gardens only
PT_indigenous <- PT_analysis_data %>%
  filter(is_indigenous_garden == 1) %>%
  group_by(nia_or_en) %>%
  summarise(count = n(), .groups = "drop")

# Create a bar chart
ggplot(PT_indigenous, aes(x = nia_or_en, y = count, fill = nia_or_en)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Count of Indigenous-Led Gardens by Neighborhood Type",
    x = "Neighborhood Type (NIA or EN)",
    y = "Number of Indigenous-Led Gardens",
    fill = "Neighborhood Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Summarize the data
PT_summary_table <- PT_analysis_data %>%
  group_by(nia_or_en) %>%
  summarise(
    Total_Gardens = n(), # Total number of gardens in each neighborhood type
    Indigenous_Gardens = sum(is_indigenous_garden), # Count of Indigenous-led gardens
    Non_Indigenous_Gardens = Total_Gardens - Indigenous_Gardens, # Count of Non-Indigenous gardens
    Proportion_Indigenous = (Indigenous_Gardens / Total_Gardens) * 100, # Proportion of Indigenous gardens
    .groups = "drop"
  )

# Display the table
PT_summary_table %>%
  kable(
    caption = "Summary of Gardens by Neighborhood Type",
    col.names = c(
      "Neighborhood Type (NIA or EN)", 
      "Total Gardens", 
      "Indigenous-Led Gardens", 
      "Non-Indigenous Gardens", 
      "Proportion Indigenous (%)"
    )
  )

# Create the scatter plot with a trendline
ggplot(PT_analysis_data, aes(x = log1p(estimated_garden_size), y = log1p(number_of_gardens))) +
  geom_point(color = "blue", alpha = 0.6) + # Scatter points
  geom_smooth(method = "lm", color = "red", se = TRUE) + # Trendline (linear regression)
  labs(
    title = "Log-Transformed Relationship Between Garden Size and Number of Gardens",
    x = "Log(Estimated Garden Size + 1)",
    y = "Log(Number of Gardens + 1)",
    caption = "Source: PollinateTO Dataset"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5), # Center the title
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotate x-axis labels if needed
  )

# Add a log-transformed column for garden size
PT_analysis_data <- PT_analysis_data %>%
  mutate(log_garden_size = log1p(estimated_garden_size)) # log1p handles zero values safely

# Use the log-transformed column in the dotplot
ggplot(PT_analysis_data, aes(x = nia_or_en, y = log_garden_size, fill = nia_or_en)) +
  geom_dotplot(binaxis = "y", stackdir = "center", dotsize = 0.8) +
  scale_fill_brewer(palette = "Pastel1") +
  labs(
    title = "Log-Transformed Garden Sizes by Neighborhood Type",
    x = "Neighborhood Type (NIA or EN)",
    y = "Log of Estimated Garden Size",
    fill = "Neighborhood Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

