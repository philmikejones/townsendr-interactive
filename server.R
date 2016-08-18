
library("shiny")
library("leaflet")
library("magrittr")
library("dplyr")

lad_map <- readRDS("data/lad_shp.rds")

shinyServer(function(input, output) {

  output$map  <- renderLeaflet({

      leaflet(lad_map) %>%
        addTiles(
          attribution = "Townsend"
        )

  })

  output$info <- renderPrint({

    nearPoints(lad_map, input$plot_click)

  })

})
