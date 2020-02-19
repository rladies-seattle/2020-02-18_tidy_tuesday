library(shiny)
library(shinyjs)
library(tidyverse)

shinyServer(function(input, output) {
  
  ##### Download plot as png #####
  output$downloadPlot <- downloadHandler(
    filename = function() { paste('food.plot',
                                  '.png', sep='') },
    content = function(file) {
      ggsave(file, plot = plotInput(), device = "png")
    }
  ) 
  
  ##### Create plot ##### 
  plotInput <- reactive({

    #Load data
    set.seed(100)
    dat <- read_csv("food_consumption.csv")
    
    out <- dat %>% 
    #Subset 
        filter(country %in% c(input$country)) %>% 
        filter(food_category %in% c(input$food)) %>% 
      
        pivot_longer(c(consumption, co2_emmission),
                     names_to = "name", values_to = "value")  %>% 
     #Plot 
        ggplot(aes(x=reorder(country, value), y=value, fill=country)) +
        geom_col( ) +
        theme_classic( ) +
        facet_grid(name ~ food_category,
                   labeller = labeller(
                     name = c("co2_emmission" = "CO2 emissions",
                              "consumption" = "Total consumption"))) +
        labs(x="Country", y="") +
        theme(axis.text.x = element_text(angle = 90),
              legend.position = "none")
  })
  
  
  ##### Render plot ##### 
  output$graphPlot <- renderPlot({
    print(plotInput())
    
  }
  ) # end renderPlot
  
})
