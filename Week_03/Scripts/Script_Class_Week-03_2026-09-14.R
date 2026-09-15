## This code is for practicing creating a plot
##
## Created by: Ellie S Jones
## Created on: 2026-09-14
## Last updated: 2026-09-14
####################################################################

## Load libraries, view the penguin data from Palmer Penguins package
library(tidyverse)
library(here)
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

## Code ggplot to develop a scatter plot of penguin data and specify the aesthetics using mapping
ggplot(data=penguins,
       mapping = aes(x=bill_depth_mm,
                     y=bill_length_mm,
                     color=species,
                     alpha=body_mass_g))+
  geom_point()+
  labs(title="Bill Depth and Length",
       subtitle="Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
       x = "Bill Depth (mm)", y = "Bill Length (mm)",
       color = "Species",
       caption = "Source: Palmer Station LTER / palmerpenguins package")+
  scale_color_viridis_d()

## Code ggplot with a facet to explore relationships within the data
ggplot(penguins,
       aes(x=bill_depth_mm,
           y=bill_length_mm,
           color=species))+
  geom_point()+
  scale_color_viridis_d()+
  facet_grid(species~sex)+
  guides(color="none")
