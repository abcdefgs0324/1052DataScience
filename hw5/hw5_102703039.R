########################
# homework5
# GOAL: Implement n-fold cross-validation.
# DATE: 17/05/23
########################

# read parameters
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
    stop("USAGE: Rscript hw5_102703039.R -fold n -out performance.csv", call.=FALSE)
}

# parse parameters
i <- 1
while(i < length(args)) {
    if(args[i] == "--fold"){
        n <- as.numeric(args[i+1])
        i <- i+1
    }else if(args[i] == "--out"){
        out_f <- args[i+1]
        i <- i+1
    }else{
        stop(paste("Unknown flag", args[i]), call.=FALSE)
    }
    i <- i+1
}

library(class)

input <- "Archaeal_tfpssm.csv"
data <- read.csv(input, header=F)
levels(data[,2])
head(data[,5600:5603])

knn(data[1:800,3:5602], data[801:805,3:5602], data[1:800,2], k=5)
