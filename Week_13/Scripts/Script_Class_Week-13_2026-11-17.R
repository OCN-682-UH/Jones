# This script is for learning how to do iterative coding
# Created by: Ellie S Jones
# Created on: 2026-11-17
# Last updated: 2026-11-17
#
################################################

library(tidyverse)
library(here)

## Practice simple for loops
print(paste("The year is",2000))
years <- c(2015:2021)
for(i in years){                   # i is the index
  print(paste("The year is",i))    # Loop over i
}

## To save a new vector with all the years you are looping, you need to pre-allocate space and tell R where it is going to be saved
year_data <- tibble(year = rep(NA, length(years)),
                    year_name = rep(NA, length(years)))   # Create an empty dataframe called year_data with columns for year and year_name
year_data

## Add the for loop, one line at a time
for(i in seq_along(years)){
  year_data$year_name[i] <- paste("The year is",years[i])
  year_data$year[i] <- years[i]
}
year_data

## Using loops to read in multiple .csv files
testdata <- read_csv(here("Week_13","Data","cond_data","011521_CT316_1pcal.csv"))
glimpse(testdata)                                        # Read in one of the files to view
CondPath <- here("Week_13","data","cond_data")           # Point to the folder on the computer
files <- dir(path = CondPath, pattern = ".csv")          # List all files in that path matching a pattern (here, anything with .csv)
files
cond_data <- tibble(filename = rep(NA, length(files)),   # Pre-allocate space for the loop, creating one row for each file and three columns
                    mean_temp = rep(NA, length(files)),
                    mean_sal = rep(NA, length(files)))
cond_data
raw_data <- read_csv(paste0(CondPath,"/",files[1]))      # Write the basic code by reading in the first file
head(raw_data)
mean_temp <- mean(raw_data$Temperature,na.rm = TRUE)     # Test the basic code
mean_temp
for(i in seq_along(files)){
  raw_data <- read_csv(paste0(CondPath,"/",files[i]))
  cond_data$filename[i] <- files[i]
  cond_data$mean_temp[i] <- mean(raw_data$Temperature,na.rm=TRUE)
  cond_data$mean_sal[i] <- mean(raw_data$Salinity,na.rm=TRUE)
}
cond_data

## Iterative coding in purrr using map functions
1:10                   # Create a vector from 1 to 10
# For each value in 1 to 10, make a vector of 15 random numbers from a normal distribution
set.seed(3817)         # Makes the random numbers reproducible
1:10 |>                # The vector to iterate over
  map(rnorm, n=15) |>  # 15 random numbers from a normal distribution, in a list
  map_dbl(mean)        # The result is now a vector of type "double"
1:10 |>
  map(function(x) rnorm(15,x)) |>   # Make it into a function!
  map_dbl(mean)
1:10 |>
  map(~ rnorm(15, .x)) |>           # Changes the arguments inside the function
  map_dbl(mean)
# Because we used the same seed, all three notations give identical results

## Bring in your files using purrr instead of a for loop
CondPath <- here("Week_13","Data","cond_data")
files <- dir(path = CondPath, pattern = ".csv")
files
# You can also get the full file names in one less step
files <- dir(path = CondPath, pattern = ".csv", full.names = TRUE)
files
# Read in the files using map instead of a for loop, then stack the list of dataframes into one list with list_rbind, keeping the filename as a column
data <- files |>
  set_names() |>                      # Names each list element with its file name
  map(read_csv) |>                    # A list of 3 dataframes
  list_rbind(names_to = "filename")   # Stack them; list names go in a "filename" column
data
# Now we have a regular dataframe and can calculate means the way we already know how with group_by and summarise
data <- files |>
  set_names() |>
  map(read_csv) |>
  list_rbind(names_to = "filename") |>
  group_by(filename) |>
  summarise(mean_temp = mean(Temperature, na.rm=TRUE),
            mean_sal = mean(Salinity, na.rm=TRUE))
data

## Shortcut: readr can read many files at once
data <- read_csv(files,id = "filename") |>
  group_by(filename) |>
  summarise(mean_temp = mean(Temperature,na.rm=TRUE),
            mean_sal = mean(Salinity,na.rm=TRUE))
data

## You can also use purrr to create a plot for every file (a function side effect rather than a returned value)
file_names <- dir(path = CondPath, pattern = ".csv") # just the file names

save_temp_plot <- function(file_name) {
  site_name <- str_remove(file_name, "\\.csv")
  
  p <- read_csv(paste0(CondPath, "/", file_name)) |>
    ggplot(aes(x = date, y = Temperature)) +
    geom_line() +
    labs(title = site_name, x = "Date", y = "Temperature (°C)")
  
  ggsave(here("Week_13", "output", paste0(site_name, "_temp.png")),
         plot = p, width = 6, height = 4)
}

walk(file_names, save_temp_plot)

## You can use for loop to create a plot for every file
file_names <- dir(path = CondPath, pattern = ".csv") # just the file names

for (i in seq_along(file_names)) {
  
  raw_data <- read_csv(paste0(CondPath, "/", file_names[i]))
  
  site_name <- str_remove(file_names[i], "\\.csv") # drop ".csv" for the title
  
  p <- ggplot(raw_data, aes(x = date, y = Temperature)) +
    geom_line() +
    labs(title = site_name, x = "Date", y = "Temperature (°C)")
  
  ggsave(here("Week_13", "output", paste0(site_name, "_temp.png")),
         plot = p, width = 6, height = 4)
}
dir(here("Week_13", "output"), pattern = "_temp.png")

