library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(sas7bdat)
library(shiny)
library(DT)
library(plyr)

shinyServer(function(input, output, session) {
  #AVAILABLE OUTPUT REACTIVES
  out1 <- reactiveValues()
  out2 <- reactiveValues()
  out3 <- reactiveValues()
  
  #OBSERVATION: 
              #EXCEL :: RANDOMIZER
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
    output$XLrandomizerOut <- DT::renderDataTable({
      DT::datatable(out3$out)
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
  
  
  #OBSERVATION: 
              #EXCEL :: TEST_SERIALIZER  INPUT
  observeEvent(input$inputXL2,{
    origdata <- reactive({
      read.xlsx(input$XLserializeFile[,c("datapath")], 1)
    })
    out1$out<-origdata()
    output$XLserializedIn <- DT::renderDataTable(
      out1$out, selection = list(mode = 'single', target = 'column')
    )
  })
  
  proxy = dataTableProxy('XLserializedIn')
  output$info = renderText({
    input$XLserializedIn_columns_selected
  })
  
  
  sorInput<-function(xcol, fl){
    fl<-as.data.frame(fl)
    fl<-fl[order(fl[,xcol]),]
    return(fl)
  }
  
              #EXCEL :: TEST_SERIZLER SUBMIT
  observeEvent(input$serializeXL2,{
    out2$out<-addSerial.atCol(input$XLserializedIn_columns_selected, out1$out)
    output$XLserializedOut<-DT::renderDataTable(out2$out)
  })
  #this would need to be based off post serialization column number
    #if it worked...
  observeEvent(input$SortserializeXL2,{
    out3$out<-sorInput(input$XLserializedIn_columns_select,out2$out)
    output$XLserializedOut<-DT::renderDataTable(out3$out)
  })
  
  output$XLserializedDL <- downloadHandler(
    filename = function() {
      paste(input$XLserializeFile, '.csv', sep = '')
    },
    content = function(file) {
      write.csv(as.matrix(out3$out), file)
    }
  )
  #OBSERVATIONS END
})
