### This script is for learning to work with strings in class
###
### Created by: Ellie S Jones
### Created on: 2026-10-27
### Last edited: 2026-10-31
###################################################################

## Load libraries
library(tidyverse)
library(here)
library(praise)
library(tidytext)
library(wordcloud)
library(janeaustenr)

## Practice with manipulation
paste("High temp", "Low pH")               # Paste words together
paste("High temp", "Low pH", sep="-")      # Add a dash between the words
paste0("High temp", "Low pH")              # Remove the space between words

shapes <- c("Square","Circle","Triangle")      # Working with vectors
paste("My favorite shape is a", shapes)
two_cities <- c("best","worst")
paste("It was the", two_cities, "of times.")   # Very useful when making labels for your plots

shapes                              # Pulling a string to work with individual characters
str_length                          # How many letters are in each word?
seq_data <- c("ATCCCGTC")
str_sub(seq_data, start=2, end=4)   # Extract specific characters in a string

str_sub(seq_data, start=3, end=3) <- "A"    # Modify strings by adding an A in the 3rd position
seq_data
str_dup(seq_data, times=c(2,3))             # Duplicate patterns in your strings, by 2 and 3

## Practice with whitespace
badtreatments <- c("High", " High", "High ", "Low", "Low")
badtreatments                                   # Pretend you have columns with some extra spaces that R now thinks are entirely new words
str_trim(badtreatments)                         # Use str_trim to remove the white spaces
str_trim(badtreatments, side = "left")          # Or designate the side you want the spaces removed from
str_pad(badtreatments,5,side="right")           # str_pad adds white space (in this case, to the right side of the 5th character)
str_pad(badtreatments,5,side="right",pad="1")   # Add a character instead of a white space


## Practice with locale sensitive operations
## These will perform differently in different places of the world with different languages, but default is English
x <- "I love R!"
str_to_upper(x)        # Make everything upper case
str_to_lower(x)        # Make everything lower case
