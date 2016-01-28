
library(shiny)

shinyUI(fluidPage(
  tagList(
    tags$head(
      tags$link(rel="stylesheet", type="text/css",href="style.css")
    )
  ),
  titlePanel("MasterMind App"),
    sidebarPanel(h3("Guess Selector"),
                  tags$div(class = "colpicker", 
                           selectInput("Col1", "Color #1", c("black", "red", "green", "blue", "purple", "grey", "orange")),
                           selectInput("Col2", "Color #2",c("black", "red", "green", "blue", "purple", "grey", "orange")),
                           selectInput("Col3", "Color #3",c("black", "red", "green", "blue", "purple", "grey", "orange")),
                           selectInput("Col4", "Color #4", c("black", "red", "green", "blue", "purple", "grey", "orange"))
                           ),
                  actionButton("Submit", "Submit Guess", class = "sButton"),
                  actionButton("Refresh", "Refresh Game", class = "sButton")
               ),
  mainPanel(h3("Feedback:"),
            tableOutput("results")
            )
))
