
library("shiny")
library("ggplot2")
library("magrittr")
library("dplyr")

map = readRDS("data/townsend_lad.rds")

shinyServer(function(input, output) {

  townsend_lad <- function() {

    ggplot() + geom_polygon(data = map, aes(long, lat, group = group, fill = z),
                            colour = "black") +
      coord_equal()

  }

  output$map  <- renderPlot({ townsend_lad() })

  output$info <- renderPrint({

    nearPoints(map, input$plot_hover) %>%
      select(id, z, name) %>%
      unique()

  })

})
