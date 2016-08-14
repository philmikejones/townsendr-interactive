
library(shiny)

map_lad <- readRDS("data/townsend_lad.rds")

shinyServer(function(input, output) {

  output$townsend <- renderPlot({

    polygon(map_lad, aes(long, lat, group = group), fill = NA, colour = "red") +
      coord_equal()

  })

})
