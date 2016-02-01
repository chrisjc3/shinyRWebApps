library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(sas7bdat)
library(shiny)
library(DT)

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
  
              #EXCEL :: TEST_SERIZLER SUBMIT
  defSerialCol<-function(xcol, fl){
    #TAKE fl[,xcol] as unique list
    fHld<-unique(fl[,xcol])
    fHldLen<-length(fHld)
    i<-1
    hld<-cbind("NA","NA")
    #CBIND an integer to count through uniques
    while(i<=fHldLen){
      hrow<-cbind(i, fHld[i])
      hld<-rbind(hld, hrow)
      i<-i+1
    }
    hld<-hld[1:fHldLen+1,]
    #how to insert to right of fl[,xcol]
    
    
    
    return(hld)
  }
  
  #DEBUG OUTPUT
  observeEvent(input$submitXL2,{
    out2$out<-defSerialCol(input$XLserializedIn_columns_selected, as.matrix(out1$out))
    output$XLserializedOut<-renderTable({as.matrix(out2$out)})
  })
  
  #DT OUTPUT
#   observeEvent(input$submitXL2,{
#     out2$out<-defSerialCol(input$XLserializedIn_columns_selected, out1$out)
#     output$XLserializedOut<-DT::renderDataTable(out2$out)
#   })
#   
  #OBSERVATIONS END
})
