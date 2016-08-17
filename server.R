
library("shiny")
library("leaflet")
library("magrittr")
library("dplyr")

map <- readRDS("data/lad_shp.rds")

shinyServer(function(input, output) {

  lad_score <- function() {

    leaflet(map) %>%
      addPolygons()

  }

  output$map  <- renderPlot({ lad_score() })

  output$info <- renderPrint({

    nearPoints(map, input$plot_click) %>%
      select(id, z, name) %>%
      unique()

  })

})
