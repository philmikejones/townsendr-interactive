
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

    mainPanel(
      plotOutput('map', click = "plot_click", height = 1200, width = 1000),
      verbatimTextOutput("info")
    )

))
