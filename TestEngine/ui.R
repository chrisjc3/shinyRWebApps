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
      sliderInput(
        "how_many_questions", "How many questions?",
        min = 5, max = 120, value = 5, step = 1, round = 0
      ),
      actionButton("startTest", "Start"),
      actionButton("refreshTest", "Refresh")
    ),
    sidebarPanel(
      "Answer Options",
      checkboxGroupInput("aOptions", "Options", choices = NULL),
      actionButton("submitAnswer","Submit"),
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
            imageOutput("explanation")
            )
))