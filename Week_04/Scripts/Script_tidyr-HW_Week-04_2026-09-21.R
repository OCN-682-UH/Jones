## This code is for practicing tidyr with biogeochem data for homework
##
## Created by: Ellie S Jones, even though kitten Prince was valiantly attempting to stop me from coding by attacking my fingers on the keyboard
## Created on: 2026-09-21
## Last updated: 2026-09-21
####################################################################

## Load Libraries
library(tidyverse)
library(here)
library(fishualize)
library(praise)

## Load and look at data
ChemData <- read_csv(here("Week_04","Data","chemicaldata_maunalua.csv"))
view(ChemData)

## Clean, filter, and pivot data
ChemData_filtered <- ChemData |>
  filter(complete.cases(ChemData)) |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide","Time")) |>
  filter(Zone=="Transition"|Zone=="Diffuse")          # Filter out data from the transition and diffuse zones, excluding ambient and near spring
View(ChemData_filtered)                               # View the data to make sure my code is running properly, and it is! Yay! Onto the pivot.
# But first, praise
praise()
ChemData_longer <- ChemData_filtered |>
  pivot_longer(cols = Temp_in:percent_sgd,     
               names_to = "Variables",         
               values_to = "Values")                  # Pivot to long data
View(ChemData_longer)

## Calculate summary statistics for data
ChemData_sgd <- ChemData_longer |>
  filter(Variables=="Temp_in"|Variables=="percent_sgd"|Variables=="Salinity")    # Filter out temp, sal, and sgd
View(ChemData_sgd)
ChemData_calc <- ChemData_sgd |>
  group_by(Variables,Zone,Season) |>
  summarise(Param_means = mean(Values),
            Param_vars  = var(Values),
            Param_sd = sd(Values),
            Param_min = min(Values),
            Param_max = max(Values)) |>               # Calculate the mean, variance, standard deviation, minimums, and maximums
  write_csv(here("Week_04","Outputs","ChemData_HW_Summary.csv"))
View(ChemData_calc)

## Make a plot with the data showing means of temperature, salinity, and SGD
ChemData_calc |>
  ggplot(aes(x = Variables, y = Param_means,fill=Variables)) +
  geom_col() +
  labs(title = "Mean Temperature, Salinity, and SGD",
    x = "Variables",
    y = "Means",
    color="Variables")+
  scale_x_discrete(labels = c(percent_sgd = "Percent SGD",Salinity="Salinity",Temp_in="Temperature"))+
  scale_color_fish_d(option="Coryphaena_hippurus")+
  theme_minimal()+
  theme(legend.position="none")
