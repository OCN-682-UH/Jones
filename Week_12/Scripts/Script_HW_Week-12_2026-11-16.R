# This script is for testing code for a Shiny App for Week 12 homework
# Created by: Ellie S Jones
# Created on: 2026-11-16
# Last updated: 2026-11-16
#
################################################

library(shiny)
library(tidyverse)
library(here)

## Call the data to use in the app
fishes <- read_csv(here("Week_12/Data/WPacFIN_data.csv"))
view(fishes)

## Filter for invasive fish species of interest
inv_fishes <- fishes |>
  filter(`Scientific Name`=="Cephalopholis argus"|
           `Scientific Name`=="Lutjanus kasmira"|
           `Scientific Name`=="Lutjanus fulvus")
view(inv_fishes)

## Create a bar plot of fisheries landings
inv_fishes |>
  ggplot(aes(x=`Scientific Name`,
             y=`Estimated Lbs. Landed`,
             fill=`Scientific Name`)) +
  geom_col() +
  labs(title = "Fisheries Landings for 3 Invasive Species in Hawaiʻi",
       x = "Species", y = "Estimated Landings (lbs)") +
  theme_minimal() +
  theme(legend.position = "none")
