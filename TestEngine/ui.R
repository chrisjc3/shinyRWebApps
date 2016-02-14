library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)
library(DT)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      "Test Options",
      
      #SHOULD PROBABLY BE REACTIVE ON HOW MANY ARE READ FROM ANSWERS.XLSX
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
      h6("Correct Counter:"),
      textOutput("Corrects"),
      h6("Incorrect Counter:"),
      textOutput("Incorrects"),
      h6("Final Score:"),
      textOutput("corPerct")
    )
    
  ),
  mainPanel(
    "Question Info",
    imageOutput("question"),
    uiOutput("fResHd"),
    tableOutput("feedback"),
    
    uiOutput("prevIFB"),
    uiOutput("nextIFB"),
    
    br(),
    tableOutput("currIC"),
    br(),
    imageOutput("fQuestion")
    
  )
  
))