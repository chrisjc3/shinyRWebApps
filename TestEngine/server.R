library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)


shinyServer(function(input, output, session) {
  out1 <- reactiveValues()
  
  turnCtr <- function(x) {
    if (is.na(x)) {
      return(0)
    } else {
      return(x + 1)
    }
  }
  
  observeEvent(input$startTest,{
    TurnMax <<- input$how_many_questions
    if (input$startTest == 1) {
      turn <<- 0
    }
    turn <<- turnCtr(turn)
    if (turn <= TurnMax & turn != 0) {
      out1$out <- list(
        src = paste0("www/questions/que_", turn,".png"),
        width = 800,
        height = 250
      )
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      
      out1$ansData <- read.xlsx("www/ANSWERS.xlsx",1)
      out1$ansRow <- subset(out1$ansData, out1$ansData[,1] == turn)
      out1$corAns <- out1$ansRow[,2]
      out1$aChoices <- out1$ansRow[1,3:6]
      
      updateCheckboxGroupInput(
        session, "aOptions",
        choices = list(
          as.character(out1$aChoices[,1]),
          as.character(out1$aChoices[,2]),
          as.character(out1$aChoices[,3]),
          as.character(out1$aChoices[,4])
        )
      )
    }
    
  })
  
  observeEvent(input$submitAnswer,{
    # output$test<-renderText({out1$corAns})
    ###################4:
    #log feedback
    
    
    
    #PROCESS NEXT QUESTION:
    turn <<- turnCtr(turn)
    if (turn <= TurnMax & turn != 0) {
      out1$out <- list(
        src = paste0("www/questions/que_", turn,".png"),
        width = 800,
        height = 250
      )
      
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      
      out1$ansData <- read.xlsx("www/ANSWERS.xlsx",1)
      out1$ansRow <- subset(out1$ansData, out1$ansData[,1] == turn)
      out1$corAns <- out1$ansRow[,2]
      out1$aChoices <- out1$ansRow[1,3:6]
      updateCheckboxGroupInput(
        session, "aOptions",
        choices = list(
          as.character(out1$aChoices[,1]),
          as.character(out1$aChoices[,2]),
          as.character(out1$aChoices[,3]),
          as.character(out1$aChoices[,4])
        )
      )
    } else if (turn > TurnMax) {
      #output results?
      updateCheckboxGroupInput(session, "aOptions", choices = character(0))
      out1$out <- list(
        src = paste0("www/questions/finished.png"),
        width = 250,
        height = 250
      )
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      
    }
  })
  
  
  
  
  
  
  
  ###################5:
  #sidebar panel should show instance correct/incorrect counts.
  #sidebar panel should button to export results
  #(or maybe do it automatically when complete?)
  
})