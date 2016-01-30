
library(shiny)
library(shinyjs)

shinyServer(function(input, output, session) {
  #DUPLICATE shinyjs::onclick PER PEX
  shinyjs::onclick("Ex1Proc",
                   shinyjs::toggle(id = "EX1"))
  shinyjs::onclick("Ex2Proc",
                   shinyjs::toggle(id = "EX2"))  

  observeEvent(input$resB, {
    session$reload();
  })
  
  outnow <- reactiveValues()
  #DUPLICATE observeEvent PER BUTTON AND INPUT SLIDER/whathaveyou
  observeEvent(input$submit1, {
    outnow$out<-ProjEul1(input$Ex1N)
  })
  observeEvent(input$submit2, {
    outnow$out<-ProjEul2(input$Ex2N)
  })
  
  #RENDER RESULTS
  output$results <- renderText({outnow$out})
 
})
