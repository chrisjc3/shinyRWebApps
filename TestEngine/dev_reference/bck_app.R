
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_71')

library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)    
library(sas7bdat)

GenRand<-function(x){
  return(sample(1:x, 1))
}

CCipher<-function(x, ent, c_key, n_key){
  #SETUP CIPHER 
  keyTable<-NULL
  out<-NULL
  alphabet <- letters[1:26]
  alphabet <- c(alphabet, alphabet)
  numbers <- seq(1:9)
  numbers <- c(numbers, numbers)
  change_c <- FALSE
  change_n <- FALSE
  for(col in x ){
    colnm <- names(ent[col])
    out<-c("NA")
    names(out) <- colnm
    for(i in seq(along=ent[,1])) {
      curVal<- ent[i,c(colnm)]
      entarr <- unlist(strsplit(tolower(as.character(curVal)), ""))
      outline <- entarr
      for(w in seq(along=entarr)){
        if (is.character(entarr[w]) == TRUE) {
          for(k in seq(along=alphabet)) {
            if (k > 26 & as.character(entarr[w]) == as.character(alphabet[k])) {
              arrpos <- k
              change_c <- TRUE
            }
          }
        } 
        
        if (suppressWarnings(is.na(as.numeric(entarr[w]))) == FALSE) {
          for(j in seq(along=numbers)) {
            if (j > 9 & as.numeric(entarr[w]) == as.numeric(numbers[j])) {
              arrpos <- j
              change_n <- TRUE
            }
          }
        }
        if (change_n == TRUE){ 
          outline[w] <- numbers[arrpos-n_key]
        } else if (change_c == TRUE){ 
          outline[w] <- alphabet[arrpos-c_key]
        } else {
          outline[w] <- entarr[w]
        }
        change_c <- FALSE
        change_n <- FALSE
      }
      out <- rbind(out, toupper(paste(outline, collapse="")))
    }
    ent[,col] <- out[-1]
  }
  ent
}

ui <- fluidPage(
  titlePanel("RANDOMIZER APP"),
  sidebarLayout(
    sidebarPanel("",
                 fileInput("oFile", "Original File"),
                 radioButtons("ToFile", "Type of File",
                              choices = c("EXCEL", ".CSV", ".sas7bdat")),
                 radioButtons("Idents", "Mask how many left side identifiers?",
                              choices = c("1", "2", "3", "4", "5","6", "7")),
                 actionButton("Submit","Submit"),
                 downloadLink('downloadData', 'Download')
                 ),
    mainPanel(
      "Sample Outputs",
          tableOutput("results"),
          br(),
          tableOutput("keyTbl"),
          br(),
          tableOutput("randoResults")
    )
  )
)


server <- function(input, output){
        origdata <-reactive({
          infile <- input$oFile
            if (input$ToFile == "EXCEL"){
              read.xlsx(input$oFile[,c("datapath")], 1) #endRow=5)
            } else if (input$ToFile == ".CSV"){
              read.csv(input$oFile[,c("datapath")], header = TRUE) #nrows=5)
            } else if (input$ToFile == ".sas7bdat"){
              read.sas7bdat(input$oFile[,c("datapath")])
            } else {
              return(NULL)
            }
        })
        c <- GenRand(25)
        n <- GenRand(9)
        keys <- cbind(c, n, "LEFT")
        colnames(keys) <- c("CHAR KEY", "NUM KEY", "POSITION")
        observe({
        if(input$Submit == 0){return("SELECT FILE")
        }else{       
            output$results <- renderTable({
              rslts <- origdata()
              rslts[1:5,]
            })
            output$keyTbl <- renderTable({
              keys
            })
            Seqvalues <- reactiveValues()
            output$randoResults <- renderTable({
              Seqvalues <- as.numeric(input$Idents)
              rslts <- CCipher(seq(1:Seqvalues), origdata(), c, n)
              rslts[1:5,]
            })
        }
        })
        output$downloadData <- downloadHandler(
          filename = function() {
            paste('cipher_c', c, 'n', n, 'l_', input$oFile, '.csv', sep='') 
          },
          content = function(file) {
            Seqvalues <- as.numeric(input$Idents)
            capture <- CCipher(seq(1:Seqvalues), origdata(), c, n)
            write.csv(as.matrix(capture), file)
          }
        )
}
        

shinyApp(ui = ui, server = server)














