
library("shiny")
library("leaflet")
library("magrittr")
library("sp")

ui <- fluidPage(div(class = "outer",

  # Use some css bodgery for height attribute to be flexible
  tags$style(type = "text/css", ".outer {position: fixed;
             top: 10px; left: 10px; right: 10px; bottom: 10px;
             overflow: hidden; padding: 0}"),

  leafletOutput("map", height = "100%", width = "100%")

))

server <- function(input, output, session) {

  lad_map <- readRDS("data/lad_shp.rds")

  pal <- colorNumeric(
    palette = "Blues",
    domain  = lad_map$z
  )

  output$map  <- renderLeaflet({

    leaflet(lad_map) %>%
      addPolygons(weight = 1,
                  fillOpacity = 0.8, fillColor = ~pal(z)) %>%
      addProviderTiles("OpenStreetMap.Mapnik",
                       options = providerTileOptions(opacity = 0.35)) %>%
      addLegend("bottomright", pal = pal, values = ~z,
                title = "Z-score",
                opacity = 0.8)

  })

}

shinyApp(ui, server)
