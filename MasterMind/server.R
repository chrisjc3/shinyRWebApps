

library(shiny)

shinyServer(function(input, output) {
  
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
      output$results <- renderText({turn})
      
      
    } else {
      output$results <- renderText("YOU LOSE")
    }
    

      
    })
  
  
})
