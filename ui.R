
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

    mainPanel(
      plotOutput('map', width = "100%")
    )

))
