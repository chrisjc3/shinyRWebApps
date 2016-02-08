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
  out3 <- reactiveValues()
  
  turnCtr <- function(x) {
    if (is.na(x)) {
      return(0)
    } else {
      return(x + 1)
    }
  }
  
  observeEvent(input$startTest,{
    #MAKE THE START BUTTON INITIALIZE THE SUBMIT ANSWER BUTTON
    TurnMax <<- as.numeric(input$how_many_questions)
    if (input$startTest == 1) {
      turn <<- 0
    }
    turn <<- turnCtr(turn)
    if (turn <= TurnMax & turn != 0) {
      tSample <<- read.xlsx("www/ANSWERS.xlsx",1)
      tSample <<- tSample[1:TurnMax,]
      out1$nOrd <- sample(seq_len(length(tSample[,1])),replace = FALSE)
      tSample <<- cbind(out1$nOrd,tSample)
      tSample <<- tSample[order(tSample[,1],tSample[,1]),]
      
      out1$ansRow <- subset(tSample, tSample[,1] == turn)
      out1$sQno <- out1$ansRow[,2]
      out1$corAns <- out1$ansRow[,3]
      out1$aChoices <- out1$ansRow[1,4:7]
      updateCheckboxGroupInput(
        session, "aOptions",
        choices = list(
          as.character(out1$aChoices[,1]),
          as.character(out1$aChoices[,2]),
          as.character(out1$aChoices[,3]),
          as.character(out1$aChoices[,4])
        )
      )
      out1$out <- list(
        src = paste0("www/questions/que_", out1$sQno,".png"),
        width = 800,
        height = 300
      )
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      
    }
    
  })
  
  observeEvent(input$submitAnswer,{
    if (as.character(out1$corAns) == input$aOptions) {
      out2$newline <-
        c(out1$sQno, as.character(out1$corAns), input$aOptions, "CORRECT")
      out2$feedback <- rbind(out2$feedback, out2$newline)
    } else {
      out2$newline <-
        c(out1$sQno, as.character(out1$corAns), input$aOptions, "WRONG")
      out2$feedback <- rbind(out2$feedback, out2$newline)
    }
    
    turn <<- turnCtr(turn)
    
    if (turn <= TurnMax & turn != 0) {
      out1$ansRow <- subset(tSample, tSample[,1] == turn)
      out1$sQno <- out1$ansRow[,2]
      out1$corAns <- out1$ansRow[,3]
      out1$aChoices <- out1$ansRow[1,4:7]
      updateCheckboxGroupInput(
        session, "aOptions",
        choices = list(
          as.character(out1$aChoices[,1]),
          as.character(out1$aChoices[,2]),
          as.character(out1$aChoices[,3]),
          as.character(out1$aChoices[,4])
        )
      )
      
      out1$out <- list(
        src = paste0("www/questions/que_", out1$sQno,".png"),
        width = 800,
        height = 300
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
    } else if (turn > TurnMax) {
      updateCheckboxGroupInput(session, "aOptions", choices = character(0))
      out1$out <- list(
        src = paste0("www/questions/finished.png"),
        width = 250,
        height = 300
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
      out2$fct <-
        as.numeric(length(out2$corCt[,1])) / as.numeric(TurnMax)
      output$corPerct <- renderText({
        as.character(out2$fct)
      })
      
      if (length(out2$badCt[,1]) > 0) {
        colnames(out2$badCt) <-
          c("QUESTION REPO #","ANSWER","RESPONSE","STATUS")
        output$fResHd <- renderUI({
          h3("Final Results:")
        })
        output$nextIFB <- renderUI({
          actionButton("nextIFB", label = "Next Incorrect Feedback")
        })
        #DISPLAY THE FIRST ONE
        output$feedback <-
          renderTable({
            out2$badCt
          },include.rownames = FALSE)
        
        out3$currow <- as.matrix(out2$badCt[1,1:3])
        output$currIC <- renderTable({
          out3$currow
        },include.colnames = FALSE)
        
        out3$curobs <- out2$badCt[1,1]
        
        out3$img1 <- list(
          src = paste0("www/explanations/exp_", out3$curobs,".png"),
          width = 800,
          height = 300
        )
        output$explanation <- renderImage({
          out3$img1 
        },deleteFile = FALSE)
        
        out3$img2 <- list(
          src = paste0("www/questions/que_", out3$curobs,".png"),
          width = 800,
          height = 300
        )
        output$fQuestion <- renderImage({
          out3$img2 
        },deleteFile = FALSE)
        
      } else {
        output$fResHd <- renderUI({
          h3("NAILED IT!")
        })
      }
      
      
      
    }

    observeEvent(input$nextIFB,{
      TurnMax <<- as.numeric(length(out2$badCt[,1]))
      if (input$nextIFB == 1) {
        turn <<- 1
      }
      turn <<- turnCtr(turn)
      if (turn <= TurnMax & turn != 0) {
        
        out3$currow <- as.matrix(out2$badCt[turn,1:3])
        output$currIC <- renderTable({
          out3$currow
        },include.colnames = FALSE)
        
        out3$curobs <- out2$badCt[turn,1]
      
        out3$img1 <- list(
          src = paste0("www/explanations/exp_", out3$curobs,".png"),
          width = 800,
          height = 300
        )
        output$explanation <- renderImage({
          out3$img1 
        },deleteFile = FALSE)
        
        out3$img2 <- list(
          src = paste0("www/questions/que_", out3$curobs,".png"),
          width = 800,
          height = 300
        )
        output$fQuestion <- renderImage({
          out3$img2 
        },deleteFile = FALSE)
        
      #RENDERING A PREVIOUS BUTTON WOULD BE GOOD
      }
    })
    
  })
})