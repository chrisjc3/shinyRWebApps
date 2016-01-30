

library(shiny)
library(shinyjs)

######DISCLAIMER: I AM BY NO MEANS A PROFICIENT CSS DESIGNER.##########
######        TIPS ARE WELCOME!!!                             #########

shinyUI(fluidPage(
  
  ###########TAGS/LINKS#########
  useShinyjs(),
  tagList(
    tags$head(
      tags$link(rel="stylesheet", type="text/css",href="style.css")
    ),


  ###########PICKER DIV (LEFT "SIDEBAR")####################
  tags$div(class="picker", id="pick",
           titlePanel("Project Euler Exercises"),
           fluidRow(column(12,
                           a(id="Ex1Proc", "Project Euler 1", href = "#")   
           )),
           fluidRow(column(12,
                           a(id="Ex2Proc", "Project Euler 2", href = "#")   
           ))       
           #ONE ROW PER PROBLEM SEEMS TO LOOK OK#
  ),

  
      #########DUPLICATE DIVS FOR EACH EX?...##############
            tags$div(class="Exer", id="Ex1", column(12,

                h3("Find the sum of all the multiples of 3 or 5 below x."),
                sliderInput("Ex1N", "x = ",
                            min=1, max=1000, value=1, step=1, round=0
                ),
                actionButton("gen1", "Generate"),
                tags$div(class = "reset",
                    actionButton("resB", "Reset")
                ),

                tags$div(class="rslts",
                      h1("Results"),
                      tableOutput("results")
                  )   
                )
            )

  ####TAG END    
  )
  
  
  
  #####UI END
))
