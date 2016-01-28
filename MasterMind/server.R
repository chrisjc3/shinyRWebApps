

library(shiny)

shinyServer(function(input, output) {
  
    output$cheats <- renderTable({
      GenAnswer()
    })
    
    guess <- eventReactive(input$Submit, {
      if(input$Submit == 1){turn <<- 0}
      turn <<- turnCtr(turn)
      if(turn <= TurnMax){
          guess<-MakeGuess(input$Col1,input$Col2,input$Col3,input$Col4)
      } else {
        return("YOU LOSE")
      }
    })
    
    output$results <- renderTable({
      guess()
    })
    
  
})
