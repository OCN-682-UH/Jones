## This code is for practicing with dplyr for homework part 1
##
## Created by: Ellie S Jones
## Created on: 2026-09-21
## Last updated: 2026-09-21
####################################################################

## Load Libraries
library(palmerpenguins)
library(tidyverse)
library(here)
library(fishualize)

## Load, view and inspect data
# The data is part of the palmerpenguins package
glimpse(penguins)
head(penguins)
penguins

## PART 1: Calculate mean and variance of body mass by species, island, and sex without any NAs
mean_var_penguins <- penguins |>
  select(species,island,sex,body_mass_g) |>  # Select penguin data to show body mass, species, island, and sex
  drop_na(species,island,sex,body_mass_g) |> # Remove NAs from each column
  group_by(species,island,sex) |>            # Create groups by all three variables
  mutate(mean_body_mass = mean(body_mass_g),
         var_body_mass = var(body_mass_g))   # Calculate mean and variance of body mass by the group of species, island, and sex

## PART 2: Filter out male penguins, calculate log body mass, select columns for species, island, sex, and log body mass, then plot
mean_var_penguins |>
  filter(sex=="female") |>                # Filter out male penguins so only female penguins are left
  mutate(log_mass=log(body_mass_g)) |>    # Calculate log body mass
  select(species,island,sex,log_mass) |>  # Select columns for species, island, sex, and log body mass
  ggplot(mapping=aes(x = species,
                     y = log_mass,
                     color = island))+
  geom_point()+
  labs(title="Log Body Mass of Female Penguins",
       subtitle="Mass for Adelie, Chinstrap, and Gentoo Penguins",
       x="Species",y="Log Body Mass (g)",
       caption = "Source: Palmer Station LTER / palmerpenguins package",
       color="Island")+
  scale_color_fish_d(option="Coryphaena_hippurus")+
  theme_minimal()
