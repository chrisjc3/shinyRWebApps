
library(shiny)
library(shinyjs)

ProjEul2<- function(x) {
  f<-cbind(1,1)
  s<-cbind(2,2)
  fibon<-rbind(f,s)
  colnames(fibon)<-c("it", "no")
  i<-2
  fib<-3
  while(fib<x){
    hld<- c(i, fib)
    fibon<-rbind(fibon,hld)
    i<-i+1
    fib<-as.numeric(as.character(fibon[i-1,2])) + as.numeric(as.character(fibon[i,2]))
  }
  i<-1
  fiblen<-length(fibon[,2])
  fibeven<-cbind("NA","NA")
  colnames(fibeven)<-c("it", "no")
  while(i<=fiblen){
    if(fibon[i,2]%%2==0){
      hld<-c(1,fibon[i,2])
      fibeven<-rbind(fibeven,hld)
    } 
  i<-i+1
  }
  return(sum(as.numeric(fibeven[2:length(fibeven[,2]),2])))
}


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
