input <- "Archaeal_tfpssm.csv"
data <- read.csv(input, header=F)
levels(data[,2])
head(data[,5600:5603]) 
