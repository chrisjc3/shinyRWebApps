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
  GenRand <- function(x) {
    return(sample(1:x, 1))
  }
  turnCtr <- function(x) {
    if (is.na(x)) {
      return(0)
    } else {
      return(x + 1)
    }
  }
  
  ##################TEST START OBSERVATION#################
  observeEvent(input$startTest,{
    TurnMax <<- as.numeric(input$how_many_questions)
    if (input$startTest == 1) {
      turn <<- 0
    }
    turn <<- turnCtr(turn)
    if (turn <= TurnMax & turn > 0) {

      tSample <<- read.xlsx("www/testmats/ANSWERS.xlsx",1)
      tSample <<- subset(tSample, tSample[,1] != "NA")
      ansMax <<- length(tSample[,1])
      
      hld<-NA
      obslst<-NA
      xlen<-0
      while(xlen < TurnMax){
        obs<- GenRand(length(tSample[,2]))
        suppressWarnings(if(is.na(hld)){
          hld<-subset(tSample, tSample[,1] == as.character(obs))
        } else {
          if(obs %in% obslst){
            xlen<-xlen-1
          } else {
            hld<-rbind(hld, subset(tSample, tSample[,1] == as.character(obs)))
          }
        }
        )
        xlen<-xlen+1
        obslst<-c(obslst, obs)
      }
      tSample<<-hld
      
      out1$nOrd <-
        sample(seq_len(length(tSample[,1])),replace = FALSE)
      tSample <<- cbind(out1$nOrd,tSample)
      tSample <<- tSample[order(tSample[,1],tSample[,1]),]
      tSample <<- subset(tSample, tSample[,2] != "NA")
      
      out1$ansRow <- subset(tSample, tSample[,1] == turn)
      out1$sQno <- out1$ansRow[,2]
      out1$corAns <- out1$ansRow[,3]
      
      output$aOptions <- renderUI({
        radioButtons("aOptions", "Options", c("a","b","c","d"))
      })
      output$subButton <- renderUI({
        actionButton("submitAnswer","Submit")
      })
      
      out1$out <- list(src = paste0("www/testmats/q", out1$sQno,".png"))
      output$question <- renderImage({
        out1$out
      },deleteFile = FALSE)
      
    }
    
  })
  
  
  ##################ANSWER SUBMISSION OBSERVATION#################
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
      
      out1$out <- list(src = paste0("www/testmats/q", out1$sQno,".png"))
      
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
      output$aOptions <- renderUI({
      })
      output$subButton <- renderUI({
      })
      out1$out <- list(src = paste0("www/testmats/finished.png"))
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
        
        output$feedback <-
          renderTable({
            out2$badCt
          },include.rownames = FALSE)
        
        out3$currow <- as.matrix(out2$badCt[1,1:3])
        output$currIC <- renderTable({
          out3$currow
        },include.colnames = FALSE)
        
        out3$curobs <- out2$badCt[1,1]
        
        out3$img2 <- list(src = paste0("www/testmats/fq", out3$curobs,".png"))
        output$fQuestion <- renderImage({
          out3$img2
        },deleteFile = FALSE)
        
      } else {
        output$fResHd <- renderUI({
          h3("NAILED IT!")
        })
      }
      turn <<- 1
      
    }
    })
    
    ##################FEEDBACK OBSERVATIONS#################
    ########NEXT######
    observeEvent(input$nextIFB,{
      output$prevIFB <- renderUI({
        actionButton("prevIFB", label = "Previous Incorrect Feedback")
      })
      
      TurnMax <<- as.numeric(length(out2$badCt[,1]))
      turn <<- turnCtr(turn)
      if (turn <= TurnMax & turn > 0) {
        out3$currow <- as.matrix(out2$badCt[turn,1:3])
        output$currIC <- renderTable({
          out3$currow
        },include.colnames = FALSE)
        
        out3$curobs <- out2$badCt[turn,1]
        
        out3$img2 <- list(src = paste0("www/testmats/fq", out3$curobs,".png"))
        output$fQuestion <- renderImage({
          out3$img2
        },deleteFile = FALSE)
      }
    })
    ########PREVIOUS######
    observeEvent(input$prevIFB,{
      if (turn > 1) { 
      turn <<- turn - 1
      } 
      if (turn <= TurnMax & turn > 0) {
        out3$currow <- as.matrix(out2$badCt[turn,1:3])
        output$currIC <- renderTable({
          out3$currow
        },include.colnames = FALSE)
        
        out3$curobs <- out2$badCt[turn,1]
        
        out3$img2 <- list(src = paste0("www/testmats/fq", out3$curobs,".png"))
        output$fQuestion <- renderImage({
          out3$img2
        },deleteFile = FALSE)
      }
      if(turn == 1){
        output$prevIFB <- renderUI({
          
        })
      }
    })
    
    

})