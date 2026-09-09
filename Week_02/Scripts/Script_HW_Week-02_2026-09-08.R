## This code is for practicing creating a script in a folder, importing data, and pushing it to Git for the Week 2 homework
##
## Created by: Ellie S Jones
## Created on: 2026-09-08
## Last updated: 2026-09-08
####################################################################

## Load libraries
library(tidyverse)
library(here)

## Read in data 
WeightData <- read_csv(here("Week_02","Data","weightdata.csv"))

## Inspect data/analysis
head(WeightData)
tail(WeightData)
view(WeightData)
