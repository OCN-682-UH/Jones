# This script is to learn how to create Shiny Apps
# Created by: Ellie S Jones
# Created on: 2026-11-10
# Last updated: 2026-11-10
#
################################################

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram

## USER INTERFACE SECTION
ui <- fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100
              ),
  textInput(inputId = "title",
            label = "Write a Title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist"),                            # Creates space for a plot called hist
  verbatimTextOutput("stats")                    # Creates space for stats
)

## SERVER SECTION
server <- function(input,output){
  data <- reactive({
    tibble(x=rnorm(input$num))
  })
  output$hist <- renderPlot({
    ggplot(data(),aes(x=x)) +
      geom_histogram() +
      labs(title = input$title)
  })
  
  output$stats <- renderPrint({
    base::summary(data())       # Calculate summary stats based on the numbers
  })
}

shinyApp(ui=ui,server=server)
