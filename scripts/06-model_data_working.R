#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(brms)
library(arrow)

# Load dataset
PT_analysis_data <- read_parquet("./data/02-analysis_data/PT_analysis_data.parquet")

# Prepare the data
PT_analysis_data <- PT_analysis_data %>%
  # Create a binary outcome variable for whether the garden is larger than average
  mutate(is_large_garden = ifelse(estimated_garden_size > mean(estimated_garden_size, na.rm = TRUE), 1, 0)) %>%
  # Ensure categorical variables are treated as factors
  mutate(
    garden_type = as.factor(garden_type),
    ward_name = as.factor(ward_name),
    is_indigenous_garden = as.factor(is_indigenous_garden),
    nia_or_en = as.factor(nia_or_en),
    year_funded = as.numeric(year_funded) # Treated as continuous
  )

# Fit a Bayesian logistic regression model
bayesian_model <- brm(
  formula = is_large_garden ~ garden_type + year_funded + nia_or_en + is_indigenous_garden + ward_name,
  family = bernoulli(link = "logit"), # Logistic regression for binary outcomes
  data = PT_analysis_data,
  prior = c(
    prior(normal(0, 1), class = "b"),   # Priors for coefficients
    prior(cauchy(0, 2), class = "Intercept") # Prior for intercept
  ),
  iter = 2000,  # Number of iterations for MCMC
  warmup = 500, # Warmup period for MCMC
  chains = 4,   # Number of MCMC chains
  cores = 4,    # Number of cores for parallel computation
  seed = 123    # Random seed for reproducibility
)

# Print a summary of the model
summary(bayesian_model)

# Plot posterior distributions of coefficients
plot(bayesian_model)

# Posterior summaries for all predictors
posterior_summary(bayesian_model)

# Conditional effects for a specific predictor (e.g., GARDEN_TYPE)
conditional_effects(bayesian_model, effects = "garden_type")

# Check model diagnostics
pp_check(bayesian_model) # Posterior predictive checks

# Rhat values and Effective Sample Sizes
bayesian_model$fit

#### Save model ####
saveRDS(
  bayesian_model,
  file = "./models/PT_model.rds"
)

