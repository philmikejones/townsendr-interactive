
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

    mainPanel(
      plotOutput('map', hover = "plot_hover", height = 1200, width = 1000),
      verbatimTextOutput("info")
    )

))
