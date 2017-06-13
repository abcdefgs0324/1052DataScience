library(shiny)
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("HW4 102703039"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("target", label = h4("Target:"),
                   choices = list("Male" = "male",
                                  "Female" = "female")
                   ),
      selectInput("method",
                  label = h4("Method:"),
                  c("method1" = "m1",
                    "method2" = "m2",
                    "method3" = "m3",
                    "method4" = "m4",
                    "method5" = "m5",
                    "method6" = "m6",
                    "method7" = "m7",
                    "method8" = "m8",
                    "method9" = "m9",
                    "method10" = "m10"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      #plotOutput("distPlot")
      
      tabsetPanel(
        type="tabs",
        tabPanel("Plot", ggvisOutput("plot")),
        tabPanel("Table", tableOutput("query_table"))
      ),
      
      hr(),
      tabsetPanel(
        type="tabs",
        tabPanel("Input", tableOutput("view")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
))
