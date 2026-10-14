## This code is for learning how to create and use functions in class
##
## Created by: Ellie S Jones
## Created on: 2026-10-13
## Last updated: 2026-10-13
####################################################################

## Load libraries
library(tidyverse)
library(here)

## Rescaling data
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)                  # Set a dataframe with random numbers
head(df)           # View the data

### Without a function, you have to manually rescale and mutate, then copy and paste for each column
## Instead, we create a reusable rescaling function
rescale01 <- function(x) {
  value <- (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
  return(value)}

# Use the rescale01 function to compute across each column
df |>           
  mutate(
    a = rescale01(a),
    b = rescale01(b),
    c = rescale01(c),
    d = rescale01(d))

# You can also mutate across the entire dataframe with the rescale01 function
df |>
  mutate(across(everything(), rescale01)) # One line rescales all columns!

## Creating a function for converting temperature data in Fahrenheit to Celsius
temp_C <- (temp_F - 32) * 5 / 9     # The conversion formula
f_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)
}                                   # Create a function for the conversion
f_to_celsius(32)                    # Test the function

## Create a plot with the penguin dataset
library(palmerpenguins)
library(PNWColors)

pal <- pnw_palette("Lake",3,type="discrete")

ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_manual("Island", values = pal) +
  theme_bw()

## Use functions to create a reusable plot function with the penguin dataset
myplot <- function() {pal <- pnw_palette("Lake", 3, type = "discrete")
  ggplot(penguins, aes(x = body_mass_g, y = bill_length_mm, color = island)) +
    geom_point() +
    geom_smooth(method = "lm") +
    scale_color_manual("Island", values = pal) +
    theme_bw()}          # Name and set up the function

myplot <- function(data=penguins, x, y) {pal <- pnw_palette("Lake", 3, type = "discrete") # Set default arguments
ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_color_manual("Island", values = pal) +
  theme_bw()
}          # Add flexible arguments so the function works with any data

myplot(x = body_mass_g, y = bill_length_mm)            # Test function to plot
myplot(x = body_mass_g, y = flipper_length_mm) +       # Test with different variables
  labs(x = "Body Mass (g)", y = "Flipper Length (mm)") # Layer onto the function

## Use if-else statement to execute different code based on a condition
a <- 4
b <- 5

if (a > b) {f <- 20} else {f <- 10}

f   # The function says if a is less than b, f will be 10, so we get 10 when we run f

## Use if-else in our function from above to toggle features on and off
myplot <- function(data = penguins, x, y, lines = TRUE) {
  pal <- pnw_palette("Lake", 3, type = "discrete")
  
  if (lines == TRUE) {
    ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
      geom_point() +
      geom_smooth(method = "lm") +
      scale_color_manual("Island", values = pal) +
      theme_bw()
  } else {
    ggplot(data, aes(x = {{x}}, y = {{y}}, color = island)) +
      geom_point() +
      scale_color_manual("Island", values = pal) +
      theme_bw()
  }
}

myplot(x = body_mass_g, y = flipper_length_mm)                 # Test with lines, the default setting
myplot(x = body_mass_g, y = flipper_length_mm, lines = FALSE)  # Test without lines
