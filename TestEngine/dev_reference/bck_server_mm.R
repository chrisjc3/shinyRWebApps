library(shiny)
library(shinyjs)
library(V8)

shinyServer(function(input, output, session) {
  
    game_answer <- GenAnswer()
    output$cheats <- renderTable({
      game_answer
    })
    
    
    turnCtr<-function(x){
      if(is.na(x)){
        return(0)
      } else {
        return(x+1)
      }
    }
    feedback <- eventReactive(input$Submit, {
      if(input$Submit == 1){turn <<- 0}
      turn <<- turnCtr(turn)
      if(turn <= TurnMax) {
          guess<-MakeGuess(input$Col1,input$Col2,input$Col3,input$Col4)
          fdbk<-evaluateGuess(guess, game_answer)
      } else {
        lose_state<-c("YOU LOSE! (YOU SHOULD PRESS 'REFRESH GAME')")
        return(lose_state)
      }
      
    })
    
    observeEvent(input$refresh, {
      session$reload();
    })
    
    output$results <- renderText({
      feedback()
    })

    output$turnno <- renderText({
      feedback()
      paste0("Turn Number: ", as.character(turn))
    }) 
    
})
