library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)
library(DT)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  sidebarLayout(
    sidebarPanel(
      "Test Options",
      
      #TURN THIS INTO A RENDER UI FROM SERVER...
      #SO MAX IS MAX OF NON NA ANSWERS ON ANSWERS.XLSX
      sliderInput(
        "how_many_questions", "How many questions?",
        min = 1, max = 10, value = 1, step = 1, round = 0
      ),
      actionButton("startTest", "Start"),
      actionButton("refreshTest", "Refresh")
    ),
    sidebarPanel(
      "Answer Options",
      uiOutput("aOptions"),
      uiOutput("subButton"),
      # actionButton("submitAnswer","Submit"),
      
      h6("Correct Counter:"),
      textOutput("Corrects"),
      h6("Incorrect Counter:"),
      textOutput("Incorrects"),
      h6("Final Score:"),
      textOutput("corPerct")
    )
    
  ),
  mainPanel("Question Info",
            imageOutput("question"),
            uiOutput("fResHd"),
            tableOutput("feedback"),
            uiOutput("nextIFB"),
            
            br(),
            tableOutput("currIC"),
            br(),
            imageOutput("fQuestion"),
            br(),
            imageOutput("explanation")
            )

))