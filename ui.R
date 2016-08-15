
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

    mainPanel(
      plotOutput('map', hover = "plot_hover"),
      verbatimTextOutput("info")
    )

))
