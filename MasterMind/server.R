

library(shiny)

shinyServer(function(input, output) {
  
    game_answer <- GenAnswer()
    output$cheats <- renderTable({
      game_answer
    })
    
    feedback <- eventReactive(input$Submit, {
      if(input$Submit == 1){turn <<- 0}
      turn <<- turnCtr(turn)
      if(turn <= TurnMax){
          guess<-MakeGuess(input$Col1,input$Col2,input$Col3,input$Col4)
          #guess<-cbind(guess, game_answer)
          feedback<-evaluateGuess(guess, game_answer)
      } else {
        return("YOU LOSE")
      }
    })
    
    output$results <- renderTable({
      feedback()
    })
    
  
})
