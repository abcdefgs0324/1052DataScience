library(shiny)
library(ggvis)

# k-fold
n <- 5
# Read input file
input = "input/creditcard.csv"
datasetInput <- read.csv(input, header=T)
data <- read.csv("input/creditcard_smote.csv", header=T)

methodNames <- c("1st validation", "2nd validation",
                 "3rd validation", "4th validation",
                 "5th validation")
confM <- list()
confM[[1]] <- read.csv("input/conf-1.csv", header=T)
confM[[2]] <- read.csv("input/conf-2.csv", header=T)
confM[[3]] <- read.csv("input/conf-3.csv", header=T)
confM[[4]] <- read.csv("input/conf-4.csv", header=T)
confM[[5]] <- read.csv("input/conf-5.csv", header=T)
for (i in c(1:n)) {
  rownames(confM[[i]]) <- 0:1
  colnames(confM[[i]]) <- 0:1
}
confTableRes <- read.csv("input/confSum.csv", header=T)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$viewOri <- renderTable({
    datasetInput[1:30,]
  })
  
  output$viewBal <- renderTable({
    data[1:30,]
  })
  
  output$labelSummary <- renderPrint({
    t <- table(datasetInput$Class)/nrow(datasetInput)
    names(dimnames(t)) <- c("Original, Class:(ratio)")
    print(t)
    writeLines("", sep="\n\n")
    t <- table(data$Class)/nrow(data)
    names(dimnames(t)) <- c("After SMOTE, Class:(ratio)")
    print(t)
    writeLines("", sep="\n\n")
    summary(datasetInput)
  })
  
  output$confMatrix <- renderPrint({
    for (i in c(1:n)) {
      t <- confM[[i]]
      cat(methodNames[[i]], sep="\n")
      print(t)
      writeLines("", sep="\n\n")
    }
  })
  
  confTableRes %>%
    ggvis(~Recall, ~Precision, key:=~Validation, size=~AUC) %>%
    layer_points() %>%
    add_tooltip(function(data){
      paste0(as.character(data$Validation), "<br>", "AUC: ", as.character(round(data$AUC, 4)), "<br>", "Recall: ", as.character(round(data$Recall,4)), "<br>", "Precision: ", as.character(round(data$Precision,4)))
    }, "hover") %>%
    add_axis("x", title = "Recall",
             properties = axis_props(title = list(fontSize = 12))
    ) %>%
    add_axis("y", title = "Precision",
             properties = axis_props(title = list(fontSize = 12))
    ) %>%
    bind_shiny("plot", "plot_ui")
  
  output$resSum <- renderPrint({
    print(confTableRes, row.names=FALSE, sep="\t")
  })
  
})

