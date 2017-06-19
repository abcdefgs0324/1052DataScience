library(shiny)
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  navbarPage(
    "Fraud Detection 102703039",
    tabPanel("Input",
      mainPanel(
        tabsetPanel(
          type="tabs",
          tabPanel("Data(original)", tableOutput("viewOri")),
          tabPanel("Data(after preprocess)", tableOutput("viewBal")),
          tabPanel("Summary", verbatimTextOutput("labelSummary"))
        ),
        width = 15
      )
    ),
    tabPanel("Output",
      mainPanel(       
        tabsetPanel(
          type="tabs",
          tabPanel("Confusion Matrix", verbatimTextOutput("confMatrix")),
          tabPanel("Summary", verbatimTextOutput("resSum")),
          tabPanel("Plot", ggvisOutput("plot"))
        ),
        width = 15
      )
    )
  )

))
