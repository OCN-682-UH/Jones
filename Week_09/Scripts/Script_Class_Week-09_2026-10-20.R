## This code is for learning how to create and use factors in class
##
## Created by: Ellie S Jones
## Created on: 2026-10-20
## Last updated: 2026-10-27
####################################################################

## Load libraries
library(tidyverse)
library(here)

## Load data from TidyTuesday on income distribution in the US
income_mean <- tidytuesdayR::tt_load(2021, week = 7)$income_mean

## Practice avoiding factor booby-traps
test <- c("A","1","2")
as.numeric(test)       # Returns an NA because R reads the whole thing as characters
test <- factor(test)
as.numeric(test)       # Returns underlying integer codes, not actual values
# Code will still run with these errors, so you have to keep an eye on them

## View starwars data in R
view(starwars)

## See how many of each species exist in starwars data
star_counts <- starwars |>
  filter(!is.na(species)) |>                    # Remove NAs
  mutate(species = fct_lump(species,n=3)) |>    # Lump rare levels together, keeps n most common levels and collapses everything else into "other"
  count(species)                                # 38 unique species, but most only appear once

star_counts

### Reordering factors (bc default alphabetical is almost never what you want in a plot)
## Start with a basic bar plot and reorder in descending order
star_counts |>
  ggplot(aes(x=fct_reorder(species,n,.desc=TRUE),y=n)) +   # Reorder by column
  geom_col() +
  labs(x="Species")

### Reordering line plot legends
## View income data from TidyTuesday
glimpse(income_mean)

## Summarize across data by year and quintile
total_income <- income_mean |>
  group_by(year, income_quintile) |>
  summarise(income_dollars_sum = sum(income_dollars), .groups = "drop") |>  # Drop groups that don't exist
  mutate(income_quintile = factor(income_quintile))                         # Mutate into a factor

## Create a basic line plot with legend in the wrong order
total_income |>
  ggplot(aes(x = year, y = income_dollars_sum,
             color = income_quintile)) +
  geom_line()      # Highest income group is shown at the bottom of the legend, so we want to reorder it

## Reorder by two variables
total_income |>
  ggplot(aes(x = year, y = income_dollars_sum,
             color = fct_reorder2(income_quintile, year, income_dollars_sum))) +
  geom_line() +
  labs(color = "income quintile")

## Setting levels manually
# Without levels, alphabetical by default, which makes no sense
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"))
x1
# With levels, you can set a specified order
x1 <- factor(c("Jan", "Mar", "Apr", "Dec"),
             levels = c("Jan", "Mar", "Apr", "Dec"))
x1

## Subsetting factors when filtering data
starwars_clean <- starwars |>
  filter(!is.na(species)) |>
  count(species, sort = TRUE) |>
  mutate(species = factor(species)) |>   # Convert species column to factor
  filter(n > 3)                          # Filter starwars data to only keep common species (3 or more individuals)

starwars_clean

levels(starwars_clean$species)    # Check factor levels

## Get rid of all levels that are no longer within the dataframe
starwars_clean <- starwars |>
  filter(!is.na(species)) |>
  count(species, sort = TRUE) |>
  mutate(species = factor(species)) |>
  filter(n > 3) |>
  droplevels |>                                           # Remove all unused levels
  mutate(species=fct_recode(species,"Humanoid"="Human"))  # Rename one or more levels

starwars_clean
