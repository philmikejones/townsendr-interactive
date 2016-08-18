
library("shiny")
library("leaflet")
library("magrittr")
library("dplyr")

lad_map <- readRDS("data/lad_shp.rds")

shinyServer(function(input, output) {

  lad_score <- function() {

    leaflet(lad_map) %>%
      addPolygons()

  }

  output$map  <- renderPlot({ lad_score() })

  output$info <- renderPrint({

    nearPoints(lad_map, input$plot_click)

  })

})
