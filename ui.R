
library("shiny")
library("ggplot2")

shinyUI(fluidPage(

  titlePanel("Townsend Material Deprivation Score"),

  sidebarLayout(position = "right",

    mainPanel(
      plotOutput('map', click = "plot_click")
    ),

    sidebarPanel(
      verbatimTextOutput("info")
    )

  )

))
