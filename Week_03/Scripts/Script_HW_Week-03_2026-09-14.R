## This code is for creating my own penguin plot for homework
##
## Created by: Ellie S Jones, with an assist from kitten Prince who is napping on my lap
## Created on: 2026-09-14
## Last updated: 2026-09-14
####################################################################

## Load libraries
library(palmerpenguins)
library(tidyverse)
library(here)
library(praise)
library(fishualize)
library(ggthemes)
library(ggplot2)
library(ggridges) #add ggridges package so I can play around with ridge plots

## View and inspect data
glimpse(penguins) # decided on plotting body mass by species to compare size of each species in the dataset

## Make a ggplot to view size by year
ggplot(penguins,
       aes(x=body_mass_g,       #set x axis as body mass
           y=species,           #set y axis as penguin species
           fill = species))+    #asked ggplot to fill the ridges by species
  geom_density_ridges(jittered_points = TRUE,
                      position = position_points_jitter(width = 0.05, height = 0),
                      point_size=1,
                      point_alpha=0.1)+       #added jitter points to see the raw data beneath the ridges
  theme_ridges()+                             #asked to use the ggridges function
  theme(legend.position="none")+              #removed legend which was unnecessary since species are already listed on y axis
  scale_fill_fish(option="Acanthurus_olivaceus",discrete=TRUE)+       #used ACOL color palette
  labs(title="Body Mass of Palmer Penguin Species",
       subtitle="Data from Palmer Station LTER")+
  theme(plot.title = element_text(hjust = 0.3),
    plot.subtitle = element_text(hjust = 0.4),
    axis.title.x = element_text(hjust = 0.5),
    axis.title.y = element_text(hjust = 0.5))+
  labs(x="Body Mass (g)",y="Penguin Species")       #added titles, changed axis names, and centered all text

## YAY! I like this plot! And I learned that gentoo penguins are generally bigger than chinstrap and adelie penguins!
praise()

## Save plot in Week_03 Outputs folder
ggsave(here("Week_03","Output","Mass-Penguin-Spp_HW_2026-09-14.png"))
