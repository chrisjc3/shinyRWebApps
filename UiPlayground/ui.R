library(rJava)
library(xlsx)
library(shiny)
library(XLConnect)
library(sas7bdat)
library(shiny)

shinyUI(navbarPage(
  "CDM Suite",
  tabPanel("Excel",
           tabsetPanel(
             "",
             tabPanel(
               "Randomizer",
               sidebarPanel(
                 "",
                 fileInput("XLrandomizerFile", "Original File"),
                 radioButtons(
                   "Idents", "Mask how many left side identifiers?",
                   choices = c("1", "2", "3", "4", "5","6", "7")
                 ),
                 actionButton(class =
                                "sButton","submitXL1","Submit"),
                 downloadLink('XLrandomizerDL', 'Download'),
                 div(
                   h3("Explanation:"),
                   h5("1) Input your .xlsx or .xls file using the 'Choose File' button."),
                   h5(
                     "2) Select how many identifier variables to mask using the radio buttons"
                   ),
                   h5("3) Click 'Submit'")
                 )
               ),
               mainPanel(
                 "",
                 h3("Input Preview"),
                 tableOutput("XLrandomizerIn"),
                 br(),
                 h3("Decipher Keys"),
                 tableOutput("XLrandomizerKeys"),
                 br(),
                 h3("Results Preview"),
                 tableOutput("XLrandomizerOut")
               )
             ),
             tabPanel(
               "Test Serializer",
                sidebarPanel(
                 "",
                 fileInput("XLserializeFile", "Original File"),
                 actionButton(class =
                                "iButton","inputXL2","Fetch"),
                 actionButton(class =
                                "sButton","submitXL2","Submit"),
                 downloadLink('XLserializedDL', 'Download'),
                 div(
                   h3("Explanation:"),
                   h5("1) Input your .xlsx or .xls file using the 'Choose File' button."),
                   h5("2) Click 'Fetch' to populate view"),
                   h5("3) Select Column to serialize"),
                   h5("4) Press 'Submit'")
                 )
               ),
               mainPanel(
                 "",
                 h3("Input Preview"),
                 tableOutput("XLserializedIn"),
                 br(),
                 h3("Results Preview"),
                 textOutput("XLserializedOut")
               )
             )
           )),
  tabPanel("CSV",
           tabsetPanel(
             "",
             tabPanel("Randomizer"),
             tabPanel("SAS Code Generator")
           )),
  tabPanel("SAS7BDAT",
           tabsetPanel(
             "",
             tabPanel("Randomizer"),
             tabPanel("Serialize Test"),
             tabPanel("Flat by Visit")
           ))
))