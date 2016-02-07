library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)


shinyServer(function(input, output, session) {
  observeEvent(input$refreshTest,{
    session$reload()
  })
  
  out1 <- reactiveValues()
  out2 <- reactiveValues()
  shuffAnsDB <- reactiveValues()
  
  turnCtr <- function(x) {
    if (is.na(x)) {
      return(0)
    } else {
      return(x + 1)
    }
  }
  #MAKE A SHUFFLE FUNCTION FOR ANSWERS.xlsx
    #CREATE NEW_QNO AND LEAVE QNO ALONE TO CORRELATE TO IMAGE NAMING
  
  #PERHAPS A SECOND FUNTION SHOULD JUST RETURN the que_# TO REPLACE turn
  observeEvent(input$startTest,{
    TurnMax <<- as.numeric(input$how_many_questions)
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
    if (as.character(out1$corAns) == input$aOptions) {
      out2$newline <-
        c(turn, as.character(out1$corAns), input$aOptions, "CORRECT")
      out2$feedback <- rbind(out2$feedback, out2$newline)
    } else {
      out2$newline <-
        c(turn, as.character(out1$corAns), input$aOptions, "WRONG")
      out2$feedback <- rbind(out2$feedback, out2$newline)
    }
    
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
      out2$corCt <-
        subset(out2$feedback , out2$feedback[,4] == "CORRECT")
      out2$badCt <-
        subset(out2$feedback , out2$feedback[,4] != "CORRECT")
      output$Corrects <- renderText({
        paste(length(out2$corCt[,1]), "/", TurnMax, sep = "")
      })
      output$Incorrects <- renderText({
        paste(length(out2$badCt[,1]), "/", TurnMax, sep = "")
      })
    } else if (turn > TurnMax) {
      updateCheckboxGroupInput(session, "aOptions", choices = character(0))
      out1$out <- list(
        src = paste0("www/questions/finished.png"),
        width = 250,
        height = 250
      )
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      out2$corCt <-
        subset(out2$feedback , out2$feedback[,4] == "CORRECT")
      out2$badCt <-
        subset(out2$feedback , out2$feedback[,4] != "CORRECT")
      output$Corrects <- renderText({
        paste(length(out2$corCt[,1]), "/", TurnMax, sep = "")
      })
      output$Incorrects <- renderText({
        paste(length(out2$badCt[,1]), "/", TurnMax, sep = "")
      })
      out2$fct<-as.numeric(length(out2$corCt[,1]))/as.numeric(TurnMax)
      output$corPerct <- renderText({
        as.character(out2$fct)
      })
      
      #IT COUNTS CORRECT AND INCORRECT AS IT GOES
      #ONCE LAST QUESTION INPUT:
        #Percentage correct in sidebarPanel
      #in mainPanel
        #render a "next" button to scroll through table of incorrect answers
        #each slide should have
        #Incorrect question qno, correct answer, answer input
        #& imagine of explanation.png underneath
      colnames(out2$feedback)<-c("QNO","CORRECT ANSWER","YOUR ANSWER","DEBUG")
      
      output$feedback<-renderTable({out2$feedback})
      
        
    }
    
    
    
  })
})