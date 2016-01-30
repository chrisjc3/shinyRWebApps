
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
  
  outnow<-eventReactive(input$submit1, {
    return(ProjEul1(input$Ex1N))
  })
  
  output$results <- renderText({outnow()})
 
})
