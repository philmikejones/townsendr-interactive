
library("shiny")
library("ggplot2")

map = readRDS("data/townsend_lad.rds")

shinyServer(function(input, output) {

  townsend_lad <- function() {

    ggplot() + geom_polygon(data = map, aes(long, lat, group = group, fill = z),
                            colour = "black") +
      coord_equal()

  }

  output$map <- renderPlot({ townsend_lad() }, height = 700)

})
