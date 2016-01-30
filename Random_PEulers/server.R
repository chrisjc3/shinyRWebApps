
library(shiny)
library(shinyjs)


shinyServer(function(input, output, session) {

    observe({
      shinyjs::toggle(id = "Ex1")
    })
  
    shinyjs::onclick("Ex1Proc",
                   shinyjs::toggle(id = "Ex1")
                   )

    observeEvent(input$resB, {
      session$reload();
    })
    
    
    
})
