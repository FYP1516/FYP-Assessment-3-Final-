library(ggmap)
library(ggplot2)
library(shiny)

shinyUI(fluidPage(
  titlePanel("SP map with BMI data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText(h4("Create SP map with 
        SP students' BMI data")),
      sliderInput("BMIdata",
                  "BMI value: ",
                  min = 10, max = 40,
                  value = 25,
      )
    ),    
    
    mainPanel(
      plotOutput("SPmap")
    )
  )
))
