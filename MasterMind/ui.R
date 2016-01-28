
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
                           selectInput("Col1", "Color #1", colarr),
                           selectInput("Col2", "Color #2", colarr),
                           selectInput("Col3", "Color #3", colarr),
                           selectInput("Col4", "Color #4", colarr)
                           ),
                  actionButton("Submit", "Submit Guess", class = "sButton"),
                  actionButton("Refresh", "Refresh Game", class = "sButton")
               ),
  mainPanel(h1("Feedback:"),
            h6("CHEATS:"),
            tableOutput("cheats"),
            br(),
            h6("REAL FEEDBACK:"),
            tableOutput("results")
            )
))
