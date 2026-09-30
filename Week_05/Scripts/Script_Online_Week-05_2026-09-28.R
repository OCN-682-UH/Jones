## This code is for practicing advanced plotting for online work
##
## Created by: Ellie S Jones
## Created on: 2026-09-28
## Last updated: 2026-09-28
####################################################################

## Load libraries
library(palmerpenguins)
library(tidyverse)
library(here)
library(praise)
library(fishualize)
library(ggthemes)
library(ggplot2)
library(patchwork)
library(ggrepel)
library(gganimate)
library(gifski)
library(plotly)
library(magick)

## View and inspect data
view(penguins)

## Create two simple plots with palmer penguin dataset
p1 <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_length_mm, 
             color = species)) +
  geom_point()
p1
p2 <- penguins |>
  ggplot(aes(x = sex, 
             y = body_mass_g, 
             color = species)) +
  geom_jitter(width = 0.2)
p2
p1 + p2
p1 / p2 +                                # Stack plots vertically
  plot_layout(guides = 'collect') +      # Collect legends
  plot_annotation(tag_levels = 'A')      # Add labels

## Inspect built-in mtcars dataset for use in ggrepel
head(mtcars)

## Plot data
ggplot(mtcars, aes(x = wt,                       # Without label repelling
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_text() +
  geom_point(color = 'red')
ggplot(mtcars, aes(x = wt,                       # Repel the labels with geom text repel   
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = 'red')
ggplot(mtcars, aes(x = wt,                       # Repels text in boxes
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_label_repel() +
  geom_point(color = 'red')

## Back to the penguins!
praise()

## Create a static penguin plot
penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point()

## Add a transition with + transition states
p <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() +
  transition_states(
    year,
    transition_length = 2,
    state_length = 1
  )+
  labs(title = 'Year: {closest_state}')
anim_save(here("Week_05", "Outputs", "penguin_animation.gif"), animation = p)    # Save animation as GIF


## Create an interactive scatter plot with plotly
penguins |>
  plot_ly(x = ~body_mass_g,
          y = ~bill_depth_mm,
          color = ~species,
          type = "scatter",
          mode = "markers") |>
  layout(title = "Penguin Body Mass vs Bill Depth",
         xaxis = list(title = "Body Mass (g)"),
         yaxis = list(title = "Bill Depth (mm)"))
penguins |>                                         # Animate by species with frame
  plot_ly(x = ~body_mass_g,
          y = ~bill_depth_mm,
          frame = ~species,
          color = ~species,
          type = "scatter",
          mode = "markers",
          marker = list(size = 8)) |>
  layout(title = "Penguin Characteristics",
         xaxis = list(title = "Body Mass (g)"),
         yaxis = list(title = "Bill Depth (mm)"))

## Practice using magick to read, process, and composite images
penguin <- image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")     # Read in penguin photo
penguin
penguinplot<-penguins |>                                # Create plot, again (we love penguins)
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() 
ggsave(here("Week_05", "Outputs", "penguinplot.png"))   # Save as a plot so you can put another image on top of it
penguinplot
penplot <- image_read(here("Week_05", "Outputs", "penguinplot.png"))     # Create a composite image with penguin at coordinates 70,30)
out <- image_composite(image = penplot,       composite_image = penguin, offset = "+70+30")
out

## Practice using magick to add gifs to an image
pengif <- image_read("https://media3.giphy.com/media/H4uE6w9G1uK4M/giphy.gif")
outgif <- image_composite(penplot, pengif, gravity = "center")
animation <- image_animate(outgif, fps = 10, optimize = TRUE)
animation
