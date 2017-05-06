library(shiny)
library(ggvis)

getConfusionMatrix <- function(pres, refs) {
  return(table(prediction=pres, reference=refs))
}

getSensitivity <- function(conf, target, oppo) {
  return(conf[target, target] / sum(conf[, target]))
}

getSpecificity <- function(conf, target, oppo) {
  return(conf[oppo, oppo] / sum(conf[, oppo]))
}

getPrecision <- function(conf, target, oppo) {
  return(conf[target, target] / sum(conf[target,]))
}

getF1Score <- function(conf, target, oppo) {
  prec <- getPrecision(conf, target, oppo)
  reca <- getSensitivity(conf, target, oppo)
  return(2 * prec * reca / (prec + reca))
}

files = c("methods/method1.csv", "methods/method2.csv", "methods/method3.csv",
          "methods/method4.csv", "methods/method5.csv", "methods/method6.csv",
          "methods/method7.csv", "methods/method8.csv", "methods/method9.csv", 
          "methods/method10.csv")
names <- c()
sens_male <- c()
sens_female <- c()
spes_male <- c()
spes_female <- c()
f1s_male <- c()
f1s_female <- c()

for(file in files)
{
  # read file
  name <- gsub(".csv", "", basename(file))
  d <- read.table(file, header=T, sep=",")
  names <- c(names, name)
  
  # calculate all data
  confMatrix <- getConfusionMatrix(d$prediction, d$reference)
  sen_m <- round(getSensitivity(confMatrix, "male", "female"), 2)
  spe_m <- round(getSpecificity(confMatrix, "male", "female"), 2)
  sen_f <- round(getSensitivity(confMatrix, "female", "male"), 2)
  spe_f <- round(getSpecificity(confMatrix, "female", "male"), 2)
  f1_m <- round(getF1Score(confMatrix, "male", "female"), 2)
  f1_f <- round(getF1Score(confMatrix, "female", "male"), 2)

  # append result
  sens_male <- c(sens_male, sen_m)
  spes_male <- c(spes_male, spe_m)
  sens_female <- c(sens_female, sen_f)
  spes_female <- c(spes_female, spe_f)
  f1s_male <- c(f1s_male, f1_m)
  f1s_female <- c(f1s_female, f1_f)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  query <- reactive({
    switch(input$target,
           "male" = data.frame(methods=names, specificity=spes_male, sensitivity=sens_male, F1=f1s_male),
           "female" = data.frame(methods=names, specificity=spes_female, sensitivity=sens_female, F1=f1s_female))
  })
  
  datasetInput <- reactive({
    switch(input$method,
           "m1" = read.table("methods/method1.csv", header=T, sep=","),
           "m2" = read.table("methods/method2.csv", header=T, sep=","),
           "m3" = read.table("methods/method3.csv", header=T, sep=","),
           "m4" = read.table("methods/method4.csv", header=T, sep=","),
           "m5" = read.table("methods/method5.csv", header=T, sep=","),
           "m6" = read.table("methods/method6.csv", header=T, sep=","),
           "m7" = read.table("methods/method7.csv", header=T, sep=","),
           "m8" = read.table("methods/method8.csv", header=T, sep=","),
           "m9" = read.table("methods/method9.csv", header=T, sep=","),
           "m10" = read.table("methods/method10.csv", header=T, sep=","))
  })
  
  output$summary <- renderPrint({
    summary(datasetInput())[,2:4]
  })
  
  output$view <- renderTable({
    datasetInput()
  })
  
  query %>%
    ggvis(~specificity, ~sensitivity, key:=~methods, size=~F1) %>%
    layer_points() %>%
    add_tooltip(function(data){
      paste0(as.character(data$methods), "<br>", "Specificity: ", as.character(data$specificity), "<br>", "Sensitivity: ", as.character(data$sensitivity))
    }, "hover") %>%
    add_axis("x", title = "Specificity",
      properties = axis_props(title = list(fontSize = 12))
    ) %>%
    add_axis("y", title = "Sensitivity",
             properties = axis_props(title = list(fontSize = 12))
    ) %>%
    bind_shiny("plot", "plot_ui")
  
  output$query_table <- renderTable({
    query()[, c("methods","specificity", "sensitivity", "F1")]
  })
})

