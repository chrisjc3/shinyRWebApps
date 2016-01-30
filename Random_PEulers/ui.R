


library(shiny)
library(shinyjs)

######DISCLAIMER: I AM BY NO MEANS A PROFICIENT CSS DESIGNER.##########
######        TIPS ARE WELCOME!!!                             #########

shinyUI(fluidPage(###########TAGS/LINKS#########
                  useShinyjs(),
                  tagList(
                    tags$head(
                      tags$link(rel = "stylesheet", type = "text/css",href = "style.css")
                    ),
                    
                    
                    ###########PICKER DIV (LEFT "SIDEBAR")####################
                    tags$div(
                      class = "picker",
                      titlePanel("Project Euler Exercises"),
                      a(class="ExLink", id = "Ex1Proc", "Project Euler 1", href = "#"),
                      hidden(tags$div(
                        class = "ExBox", id = "EX1",
                        fluidRow(column(
                          6,
                          h3("Find the sum of all the multiples of 3 or 5 below x."),
                          sliderInput(
                            "Ex1N", "x = ",
                            min = 1, max = 1000, value = 1, step =
                              1, round = 0
                          ),
                          actionButton(class = "sButton", "submit1", "Submit"),
                          actionButton(class = "sButton", "resB", "Reset")
                        ))
                      )),
                      a(class="ExLink", id = "Ex2Proc", "Project Euler 2", href = "#"),
                      hidden(tags$div(
                        class = "ExBox", id = "EX2",
                        fluidRow(column(
                          6,
                          h3("By considering the terms in the Fibonacci sequence whose values do not x, find the sum of the even-valued terms."),
                          sliderInput(
                            "Ex2N", "x = ",
                            min = 1, max = 4000000, value = 1, step =
                              1, round = 0
                          ),
                          actionButton(class = "sButton", "submit2", "Submit"),
                          actionButton(class = "sButton", "resB", "Reset")
                        ))
                      ))
                      
                      #ONE ROW PER PROBLEM SEEMS TO LOOK OK#
                    ),
                    
                    tags$div(class = "rslts", id = "rslts", column(12,
                                              h3("Results:"),
                                              textOutput("results")))
                    
                    ####TAG END
                  )
                  
                  #####UI END
))
                  