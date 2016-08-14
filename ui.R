
library(shiny)

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

  sidebarLayout(

    sidebarPanel(),

    mainPanel(
      renderPlot(townsend)
    )

  )

))
