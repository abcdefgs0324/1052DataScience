########################
# homework5
# GOAL: Implement n-fold cross-validation.
# DATE: 17/05/23
########################

# read parameters
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 4) {
    stop("USAGE: Rscript hw5_102703039.R --fold n --out performance.csv", call.=FALSE)
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

# read input
input <- "Archaeal_tfpssm.csv"
data <- read.csv(input, header=F)

# divide data into several groups
folds <- list()
rowCount <- nrow(data)
for (i in c(1:n)) {
    folds[[i]] <- data[((rowCount*(i-1))%/%n+1):((rowCount*i)%/%n),]
}

require(class)

K <- 3 # for knn
trainAccu <- 0
validAccu <- 0
testAccu <- 0
# n-folds cross-validation
for (i in c(1:n)) {
    testIndex <- i
    test <- folds[[testIndex]]
    validIndex <- i+1
    if (validIndex > n) {
        validIndex <- 1
    }
    valid <- folds[[validIndex]]

    train <- data.frame()
    for (j in c(1:n)) {
        if (j != testIndex && j != validIndex) {
            train <- rbind(train, folds[[j]])
        }
    }

    # for training
    trainRes <- knn(train[, 3:5602], train[, 3:5602], train[, 2], k=K)
    trainAccu <- trainAccu + length(which(trainRes == train[, 2])) / nrow(train)

    # for testing
    testRes <- knn(train[, 3:5602], test[, 3:5602], train[, 2], k=K)
    testAccu <- testAccu + length(which(testRes == test[, 2])) / nrow(test)

    # for validation
    validRes <- knn(train[, 3:5602], valid[, 3:5602], train[, 2], k=K)
    validAccu <- validAccu + length(which(validRes == valid[, 2])) / nrow(valid)
}

# average accuracy
trainAccu <- trainAccu / n
testAccu <- testAccu / n
validAccu <- validAccu / n

# conclude the result
out_data <- data.frame(set=c("training", "calibration", "test"), accuracy=c(round(trainAccu, 2), round(validAccu, 2), round(testAccu, 2)))

# output file
write.table(out_data, file=out_f, row.names=F, quote=F, sep=",")
