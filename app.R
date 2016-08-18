
library("shiny")
library("leaflet")
library("magrittr")
library("sp")

ui <- fluidPage(

  leafletOutput("map")

)

server <- function(input, output, session) {

  lad_map <- readRDS("data/lad_shp.rds")

  output$map  <- renderLeaflet({

    leaflet(lad_map) %>%
      addPolygons()

  })

}

shinyApp(ui, server)
