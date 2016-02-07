





library(shiny)
library(shinyjs)

######DISCLAIMER: I AM BY NO MEANS A PROFICIENT CSS DESIGNER.##########
######        TIPS ARE WELCOME!!!                             #########

shinyUI(fluidPage(
  ###########TAGS/LINKS#########
  useShinyjs(),
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css",href = "style.css")
    ),
    
    
    ###########PICKER DIV (LEFT "SIDEBAR")####################
    tags$div(
      class = "picker",
      titlePanel("Project Euler Exercises"),
      actionButton(class = "rButton", "resB", "Reset"),
      #SUBSTART
      a(
        class = "ExLink", id = "Ex1Proc", "Project Euler 1", href = "#"
      ),
      hidden(tags$div(
        class = "ExBox", id = "EX1",
        fluidRow(column(
          4,
          h3("Find the sum of all the multiples of 3 or 5 below x."),
          sliderInput(
            "Ex1N", "x = ",
            min = 100, max = 10000, value = 100, step =
              100, round = 0
          ),
          actionButton(class = "sButton", "submit1", "Submit")
        ))
      )),
      #SUBSTART
      a(
        class = "ExLink", id = "Ex2Proc", "Project Euler 2", href = "#"
      ),
      hidden(tags$div(
        class = "ExBox", id = "EX2",
        fluidRow(column(
          4,
          h3(
            "By considering the terms in the Fibonacci sequence whose values do not exceed x, find the sum of the even-valued terms."
          ),
          sliderInput(
            "Ex2N", "x = ",
            min = 1000, max = 40000000, value = 100000, step =
              100000, round = 0
          ),
          actionButton(class = "sButton", "submit2", "Submit")
        ))
      )),
      #SUBSTART
      a(
        class = "ExLink", id = "Ex3Proc", "Project Euler 3", href = "#"
      ),
      hidden(tags$div(
        class = "ExBox", id = "EX3",
        fluidRow(column(
          4,
          h3("What is the largest prime factor of the number x?"),
          sliderInput(
            "Ex3N", "x = ",
            min = 10000, max = 600851475143 , value = 1000000, step =
              1000000, round = 0
          ),
          actionButton(class = "sButton", "submit3", "Submit")
        ))
      )),
    #SUBSTART
    a(
      class = "ExLink", id = "Ex4Proc", "Project Euler 4", href = "#"
    ),
    hidden(tags$div(
      class = "ExBox", id = "EX4",
      fluidRow(column(
        4,
        h3("Find the largest palindrome made from the product of two x-digit numbers. (Not broken, just slow)"),
        sliderInput(
          "Ex4N", "x = ",
          min = 2, max = 6, value = 2, step =
            1, round = 0
        ),
        actionButton(class = "sButton", "submit4", "Submit")
      ))
    ))
    
    #END PICKER TAG
  ),
  
  ####RESULTS
  
  tags$div(class = "rslts", id = "rslts", column(
    12,
    h3("Results:"),
    textOutput("results")
  ))
  
  ####TAG END
)

#####UI END
))
