library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(sas7bdat)
library(shiny)

shinyServer(function(input, output, session) {
  #AVAILABLE OUTPUT REACTIVES
  out1 <- reactiveValues()
  out2 <- reactiveValues()
  out3 <- reactiveValues()
  
  #OBSERVATION: EXCEL :: RANDOMIZER
  observeEvent(input$submitXL1,{
    origdata <- reactive({
      read.xlsx(input$XLrandomizerFile[,c("datapath")], 1)
    })
    c <- GenRand(25)
    n <- GenRand(9)
    keys <- cbind(c, n, "LEFT")
    colnames(keys) <- c("CHAR KEY", "NUM KEY", "POSITION")
    out2$out <- keys
    out1$out <- origdata()
    Seqvalues <- reactiveValues()
    Seqvalues <- as.numeric(input$Idents)
    out3$out <- CCipher(seq(1:Seqvalues), origdata(), c, n)
    output$XLrandomizerIn <- renderTable({
      out1$out[1:5,]
    })
    output$XLrandomizerKeys <- renderTable({
      out2$out
    })
    output$XLrandomizerOut <- renderTable({
      out3$out[1:5,]
    })
    output$XLrandomizerDL <- downloadHandler(
      filename = function() {
        paste('cipher_c', c, 'n', n, 'l_', input$XLrandomizerFile, '.csv', sep = '')
      },
      content = function(file) {
        write.csv(as.matrix(out3$out), file)
      }
    )
  })
  #OBSERVATION: EXCEL :: TEST_SERIALIZER
  observeEvent(input$inputXL2,{
    origdata <- reactive({
      read.xlsx(input$XLserializeFile[,c("datapath")], 1)
    })
    out1$out<-origdata()
    output$XLserializedIn <- renderTable({
      out1$out[1:5,]
    })
  })
  observeEvent(input$submitXL2,{
    
  })
  
  #OBSERVATIONS END
})
