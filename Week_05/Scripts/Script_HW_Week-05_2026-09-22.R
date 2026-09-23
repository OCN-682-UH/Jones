## This code is for practicing joining and converting dates using lubridate for homework
##
## Created by: Ellie S Jones
## Created on: 2026-09-22
## Last updated: 2026-09-22
####################################################################

## Load libraries
library(tidyverse)
library(here)
library(fishualize)
library(praise)

## Read in and view data

Homework
Read in both the conductivity and depth data
Convert date columns appropriately
Round the conductivity data to the nearest 10 seconds to match depth data
Join the two dataframes using inner_join() (only exact matches)
Calculate averages of date, depth, temperature, and salinity by minute
Make a plot using the averaged data
Use pipes throughout (minimize separate dataframes)
Add comments to your code!
  Save output, data, and scripts appropriately