## This code is for practicing with dplyr 
##
## Created by: Ellie S Jones
## Created on: 2026-09-15
## Last updated: 2026-09-15
####################################################################

## Load Libraries
library(palmerpenguins)
library(tidyverse)
library(here)

## Load, view and inspect data
# The data is part of the palmerpenguins package
glimpse(penguins)

## Practice filtering by penguin sex, year, and large body mass
head(penguins)
filter(.data = penguins, sex == "female")
filter(penguins,year==2008)
fat_penguins <- filter(penguins,body_mass_g>5000)
head(fat_penguins)
filter(penguins,sex=="female",body_mass_g>5000)

## Practice filtering with Boolean operators
filter(penguins,year==2008|year==2009)
filter(penguins,island!="Dream")
filter(penguins,species=="Adelie",species=="Gentoo") # This did not work because there are no spp that are both Adelie and Gentoo, so we need to use a different expression
filter(penguins,species %in% c("Adelie","Gentoo"))

## Practice mutating columns
mutate(penguins,sum=body_mass_g+flipper_length_mm)
penguins <- mutate(penguins,chonk=if_else(body_mass_g>4000,"Big","Small"))
view(penguins)

## Practice piping and selecting
penguins |>
  filter(sex=="female") |>
  mutate(log_mass=log(body_mass_g)) |>
  select(species,island,sex,log_mass)
  
## Practice arranging
penguins |>
  arrange(body_mass_g)
penguins |>
  arrange(desc(body_mass_g))

## Practice summarizing
penguins |>
  summarise(mean_flipper=mean(flipper_length_mm,na.rm=TRUE),
            min_flipper=min(flipper_length_mm,na.rm=TRUE))

## Practice grouping and counting
penguins |>
  group_by(island,sex) |>
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length  = max(bill_length_mm, na.rm = TRUE),
            n                = n())
penguins |>
  count(species,island)

## Practice removing NAs
penguins |>
  drop_na(sex) |>
  group_by(island, sex) |>
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE))

## Practice piping into a ggplot
penguins |>
  drop_na(sex) |>
  ggplot(aes(x = sex, y = flipper_length_mm)) +
  geom_boxplot()
