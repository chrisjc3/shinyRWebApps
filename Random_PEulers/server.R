
library(shiny)
library(shinyjs)

ProjEul2<- function(x) {

  return(x)
}


shinyServer(function(input, output, session) {
  shinyjs::onclick("Ex1Proc",
                   shinyjs::toggle(id = "EX1"))
  shinyjs::onclick("Ex2Proc",
                   shinyjs::toggle(id = "EX2"))  

  observeEvent(input$resB, {
    session$reload();
  })
  
  outnow <- reactiveValues()
    
  observeEvent(input$submit1, {
    outnow$out<-ProjEul1(input$Ex1N)
  })
  observeEvent(input$submit2, {
    outnow$out<-ProjEul2(input$Ex2N)
  })
  

  output$results <- renderText({outnow$out})
 
})
