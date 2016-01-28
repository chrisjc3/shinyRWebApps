

library(shiny)

shinyServer(function(input, output) {
  
  output$cheats <- renderTable({
    GenAnswer()
  })
    observeEvent(input$Submit, {
    if(input$Submit == 1){turn <<- 0}
  
    turnCtr<-function(x){
        if(is.na(x)){
          return(0)
        } else {
          return(x+1)
        }
    }
    
    turn <<- turnCtr(turn)
    
    if(turn <= TurnMax){
      output$results <- renderTable({
        MakeGuess(input$Col1,input$Col2,input$Col3,input$Col4)
      })
      
      
    } else {
      output$results <- renderText("YOU LOSE")
    }
    

      
    })
  
  
})
