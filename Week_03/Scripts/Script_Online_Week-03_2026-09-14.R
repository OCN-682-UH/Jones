## This code is for practicing creating a new plot for the online lecture
##
## Created by: Ellie S Jones
## Created on: 2026-09-14
## Last updated: 2026-09-14
####################################################################

## Load libraries
library(palmerpenguins)
library(tidyverse)
library(here)

## View and inspect data
glimpse(penguins)

## Make a simple ggplot
Penguin_Plot_1 <- ggplot(penguins,
       aes(x=bill_depth_mm,
           y=bill_length_mm,
           group=species,
           color=species))+
  geom_point()+
  geom_smooth(method="lm")+
  labs(x="Bill length (mm)",
       y="Bill length (mm)")+
  scale_color_fish_d(option="Chlorurus_spilurus")+
  coord_polar()+
  theme_minimal()

## Load "praise" library because my words-of-affirmation-motivated self is quite thrilled to learn this exists
library(praise)
## Provide praise to celebrate the little wins of creating a simple plot
praise()

## Load "fishualize" library because it's my favorite set of color palettes
library(fishualize)

## Load color blindness package
library(colorBlindness)
cvdPlot(my_plot)

## Load ggthemes package
library(ggthemes)
?theme()

## Save plot in Week_03 Outputs folder
ggsave(here("Week_03","Output","Penguins.png"))
