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
    if(turn <= TurnMax) {
      out1$out<-list(
        src = paste0("www/questions/que_", turn,".png"),
        # src = "www/questions/que_1.png",
        width=500,
        height=250)
      } 
  })
  
  observeEvent(input$submitAnswer,{
    
  })
  #####################2:
  #need reactive variable for question number
    #steal turn counter from mastermind for question number counter
  #need to insert counter into www/questions/que_'&counter'.png
  
  ####################3:
  #populate radio buttons 
  #based on www/ANSWERS.xlsx
  #when taking ANSWERS, shuffle them first..keeping QNO, but assigning a new sort
  #find row based on &counter
  
  
  #EXAMPLE OF OUTPUT IMAGE
  output$question<-renderImage({
      out1$out
  },deleteFile=FALSE)
  
  ###################4:
  #log feedback
  
  ###################5:
  #sidebar panel should show instance correct/incorrect counts.
  #sidebar panel should button to export results 
    #(or maybe do it automatically when complete?)
  
})