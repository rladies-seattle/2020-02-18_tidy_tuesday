library(shiny)
library(shinyjs)
library(tidyverse)

dat <- read_csv("food_consumption.csv")

shinyUI(fluidPage(
  useShinyjs(),
  
  sidebarLayout(
    sidebarPanel(
      ##### COUNTRY #####
      selectInput("country","country",
                  unique(as.character(dat$country)), 
                  multiple = TRUE),
      ##### FOOD #####
      selectInput("food","food source",
                  unique(as.character(dat$food_category)), 
                  multiple = TRUE),
      br(),
      actionButton("resetAll", "Clear all"), #Clear all button does not work
      br(),br(),br(),
      downloadButton("downloadPlot", label="save plot"),
      
      tags$div(id ='placeholder'), width =3
    ), # end sidebarPanel
    mainPanel(  
      plotOutput("graphPlot")
    )# end mainPanel
  ) # end sidebarLayout
  
))
