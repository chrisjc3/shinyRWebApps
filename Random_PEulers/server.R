
library(shiny)
library(shinyjs)

shinyServer(function(input, output, session) {
  shinyjs::onclick("Ex1Proc",
                   shinyjs::toggle(id = "EX1"))
  shinyjs::onclick("Ex2Proc",
                   shinyjs::toggle(id = "EX2"))  

  observeEvent(input$resB, {
    session$reload();
  })
  
  observeEvent(input$submit1, {
    output$results <- renderText({ProjEul1(input$Ex1N)})
  })
  
 
})
