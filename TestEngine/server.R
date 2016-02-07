library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(shiny)


shinyServer(function(input, output, session) {
  #AVAILABLE OUTPUT REACTIVES
  out1 <- reactiveValues()
  out2 <- reactiveValues()
  out3 <- reactiveValues()
  #Recycled counter from MasterMind project
  turnCtr<-function(x){
    if(is.na(x)){
      return(0)
    } else {
      return(x+1)
    }
  }
  #####################1:
  #Only do any of this when submit button is pushed
    #start back to question one if submit button is pushed (ie refresh)
  observeEvent(input$startTest,{
    TurnMax<-input$how_many_questions
    if(input$startTest == 1){turn <<- 0}
    turn <<- turnCtr(turn)
    if(turn <= TurnMax & turn != 0) {
      out1$out<-list(
        #If I was going to randomize the order it'd have to be up here
          #little unecessary
        src = paste0("www/questions/que_", turn,".png"),
        width=500,
        height=250)
    }
    output$question<-renderImage({
      out1$out
    },deleteFile=FALSE)
    
    ####################3:
    #populate checkboxInput buttons 
    #based on www/ANSWERS.xlsx
    out1$ansData <- read.xlsx("www/ANSWERS.xlsx",1)
    out1$ansRow<-subset(out1$ansData, out1$ansData[,1] == turn)
    out1$corAns<-out1$ansRow[,2]
    out1$aChoices <- out1$ansRow[1,3:6]
    
    # output$test <- renderTable({out1$aChoices})
    updateCheckboxGroupInput(session, "aOptions",
                             choices=list(as.character(out1$aChoices[,1]),
                                          as.character(out1$aChoices[,2]),
                                          as.character(out1$aChoices[,3]),
                                          as.character(out1$aChoices[,4])
                                          ))
  })
  
  observeEvent(input$submitAnswer,{
    
  })
  

  

  
  ###################4:
  #log feedback
  
  ###################5:
  #sidebar panel should show instance correct/incorrect counts.
  #sidebar panel should button to export results 
    #(or maybe do it automatically when complete?)
  
})