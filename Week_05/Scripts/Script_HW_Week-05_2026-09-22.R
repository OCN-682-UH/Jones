## This code is for practicing joining and converting dates using lubridate for homework
##
## Created by: Ellie S Jones
## Created on: 2026-09-22
## Last updated: 2026-09-28
####################################################################

## Load libraries
library(tidyverse)
library(here)
library(fishualize)
library(praise)
library(ggplot2)

## Read in and view data
CondData <- read.csv(here("Week_05","Data","CondData.csv"))
View(CondData)
DepthData <- read.csv(here("Week_05","Data","DepthData.csv"))
View(DepthData)

## Set up datasets in order to join
# "date" is the column that is consistent across both datasets, so we will join that
CondData <- CondData |>
  mutate(date = mdy_hms(date),               # Mutate to convert date column to the correct ymd format
         date = round_date(date,"10 secs"))  # Format to round time to the nearest 10 sec to match DepthData

## Convert DepthData to a datetime since joining did not work the first time around bc Cond was in datetime and Depth was in character format
DepthData <- DepthData |>
  mutate(date=ymd_hms(date))

## Join the datasets
JoinCondDepth <- CondData |>
  inner_join(DepthData,by="date")
View(JoinCondDepth)

## Calculate averages of depth, temperature, and salinity by minute
MinuteData <- JoinCondDepth |>
  mutate(minute = floor_date(date, "1 minute")) |>     # Convert datetime column to time by minute
  group_by(minute) |>                                  # Group data by minute
  summarise(
    Temperature = mean(Temperature, na.rm = TRUE),     # Take average of temperature by minute group
    Salinity = mean(Salinity, na.rm = TRUE),           # Take average of salinity by minute group
    Depth = mean(Depth, na.rm = TRUE)) |>              # Take average of depth by minute group
  pivot_longer(
    cols = c(Depth,Temperature,Salinity),
    names_to = "variable",
    values_to = "value")
View(MinuteData)

## Make a wrapped plot of depth, temp, and salinity averages to compare each by minute
ggplot(MinuteData, aes(x=minute,y=value)) +                               # Call ggplot with the MinuteData that was calculated in the previous step
  geom_line(aes(color=variable),linewidth=0.8) +
  facet_wrap(~variable,scales="free_y",ncol=1,
             labeller=as_labeller(c(Depth="Depth (m)",
                                    Temperature = "Temperature (°C)",
                                    Salinity = "Salinity (PSU)")))+       # Make line graphs with the data and wrap so the plots are on top of each other vertically
  labs(title="Physical Water Parameters Collected on January 15, 2021",
       x="Time",
       y=NULL)+                                                           # Change axes titles and plot title
  scale_color_fish_d(option="Antennarius_commerson")+                     # Add fishualize colors
  theme_minimal()+
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 10, face = "bold"),
    legend.position="none"
  )                                                                       # Remove extranneous legend and edit text format

## Yay, this is a fun graph! 
praise()
