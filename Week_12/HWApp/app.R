# This script is for creating a Shiny App for Week 12 homework
# Created by: Ellie S Jones
# Created on: 2026-11-16
# Last updated: 2026-11-16
#
################################################

library(shiny)
library(tidyverse)

## Call the data to use in the app
fishes <- read_csv("Data/WPacFIN_data.csv")
view(fishes)

## Filter for invasive fish species of interest
inv_fishes <- fishes |>
  filter(`Scientific Name`=="Cephalopholis argus"|
           `Scientific Name`=="Lutjanus kasmira"|
           `Scientific Name`=="Lutjanus fulvus") |>
  mutate(Year = as.integer(Year))                      # Remove decimal points from years in table
view(inv_fishes)

## USER INTERFACE
ui <- fluidPage(
  sliderInput(inputId = "Year",
              label = "Choose a Year",
              min = 2015, max = 2025,    # Range of years to choose from
              value = 2020,              # Year that app will start on automatically
              step = 1, sep = ""         # Set selection of years
  ),
  plotOutput("fishbar"),                 # Creates space for a plot called fishbar
  tableOutput("fish_table")              # Creates space for a table with data
)

## SERVER
server <- function(input,output){
  
  filter_fishes <- reactive({                     # Set reactive data as years in dataset
    inv_fishes |>
      filter(Year == as.numeric(input$Year))
  })
  
  output$fishbar <- renderPlot({
    filter_fishes() |>
      ggplot(aes(x=`Scientific Name`,
                 y=`Estimated Lbs. Landed`,
                 fill=`Scientific Name`)) +
      geom_col() +
      scale_fill_manual(values = c(
        "Cephalopholis argus" = "#4799af",
        "Lutjanus kasmira" = "#f1b015",
        "Lutjanus fulvus" = "#711a08"
      )) +
      coord_cartesian(ylim = c(0,135000)) +                                                                                           # Set the limits of the y axis so they do not change with the year slider
      labs(title = paste("Fisheries Landings for 3 Invasive Species in Hawaiʻi (",input$Year,") from the WPacFIN Data Portal"),       # Set title to change based on year chosen in the slider
           x = "Species", y = "Estimated Landings (lbs)") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  output$fish_table <- renderTable({                                                   # Create a table to show raw data under the plot
    filter_fishes() |>
      group_by(Year,`Scientific Name`,`Hawaiian Name`) |>
      summarise(`Estimated Lbs. Landed` = sum(`Estimated Lbs. Landed`,na.rm = TRUE),   # Sum all species catches by year
                .groups = "drop")
  })
}

## APP
shinyApp(ui=ui,server=server)
