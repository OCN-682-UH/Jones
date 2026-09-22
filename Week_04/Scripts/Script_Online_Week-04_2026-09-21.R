## This code is for practicing tidyr with biogeochemistry data in the online lecture
##
## Created by: Ellie S Jones
## Created on: 2026-09-21
## Last updated: 2026-09-21
####################################################################

## Load Libraries
library(tidyverse)
library(here)
library(praise)

## Load and look at data
ChemData <- read_csv(here("Week_04","Data","chemicaldata_maunalua.csv"))
view(ChemData)

## Filter out the NAs
ChemData_clean <- ChemData |>
  filter(complete.cases(ChemData))     # Filters out everything that is not a complete row
View(ChemData_clean)

## Separate columns with both tide and time
?separate_wider_delim
ChemData_sep <- ChemData_clean |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide","Time"))

## Pivot data from wide to long
ChemData_long <- ChemData_sep |>
  pivot_longer(cols = Temp_in:percent_sgd,     # Select columns to pivot (in this case, temperature in situ to SGD)
               names_to = "Variables",         # New column for old column names
               values_to = "Values")           # New column for the values
view(ChemData_long) 

## Calculate mean and variance for all variables at each site
ChemData_long |>
  group_by(Variables,Site) |>
  summarise(Param_means = mean(Values),
            Param_vars = var(Values))

## Calculate mean, variance, and standard deviation for all variables by site, zone, and tide
ChemData_long |>
  group_by(Variables, Site, Zone, Tide) |>
  summarise(Param_means = mean(Values),
            Param_vars  = var(Values),
            Param_sd = sd(Values))

## Plot the data in boxplots
ChemData_long |>
  ggplot(aes(x = Site, y = Values)) +
  geom_boxplot() +
  facet_wrap(~Variables, scales = "free")    # Place the plots next to each other to plot all variables at once, each with their own scale

## Pivot the data back into wide format
ChemData_wide <- ChemData_long |>
  pivot_wider(names_from  = Variables,
              values_from = Values)
View(ChemData_wide)

## We learned all the pieces! Hooray! Now time to put them all together.
praise()

## Practice the full pipeline
ChemData_clean_full <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide","Time"),
                       cols_remove = FALSE) |>
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables",
               values_to = "Values") |>
  group_by(Variables,Site,Time) |>
  summarise(mean_vals = mean(Values,na.rm=TRUE)) |>
  pivot_wider(names_from = Variables,
              values_from = mean_vals) |>
  write_csv(here("Week_04","Outputs","ChemData_Summary.csv"))

View(ChemData_clean_full)

## Troubleshooting why R cannot open my file to write the csv
dir.exists("C:/Users/cjonees/Desktop/Repositories/Jones_OCN682/Week_04/Output")
getwd()
dir.exists("Output")
setwd("C:/Users/cjonees/Desktop/Repositories/Jones_OCN682/Week_04")
getwd()
dir.exists("Output")
list.files() # Turns out after all that trouble, it just couldn't see the folder because I named it Outputs instead of Output that I had typed... ah well.

## We figured out the saving issue and saved a .csv script! Yay!
praise()
