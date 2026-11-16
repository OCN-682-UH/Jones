# This script is to learn to create Shiny Apps with real data
# Created by: Ellie S Jones
# Created on: 2026-11-10
# Last updated: 2026-11-10
#
################################################

library(shiny)
library(tidyverse)
library()

## Call the data to use
stars <- read_csv(here("Week_12/StarsApp/Data/stars.csv"))
glimpse(stars)

## USER INTERFACE
ui <- fluidPage(
  selectInput(inputId = "min_stars",
              label = "Show sites with at least this many sea stars:",
              choices = c(1, 5, 10, 20),
              selected = 5
              ),
  plotOutput("star_map")
)

## SERVER
server <- function(input, output){
  kept_sites <- reactive({
    stars |>
      filter(star_no >= as.numeric(input$min_stars))
  })
  
  output$star_map <- renderPlot({
    ggplot(kept_sites(), aes(x=long,y=lat)) +
      geom_point(aes(sizze = star_no), color = "navy") +
      labs(size = "Sea stars counted")
  })
}

shinyApp(ui = ui, server = server)