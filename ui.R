
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

    mainPanel(
      plotOutput('map', click = "plot_click"),
      verbatimTextOutput("info")
    )

))
