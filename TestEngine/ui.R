library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)


shinyUI(fluidPage(
  
  sidebarLayout(
    
    sidebarPanel("Test Options", 
                 sliderInput(
                   "how_many_questions", "How many questions?",
                   min = 5, max = 120, value = 5, step = 1, round = 0),
                 actionButton("startTest", "Start")),
    sidebarPanel("Answer Options",
                 checkboxGroupInput("aOptions", "Options", choices = NULL),
                 actionButton("submitAnswer","Submit")
                )       
    
    ),
    mainPanel("Question Info",
              imageOutput("question")
    )    
  )

  
  
)