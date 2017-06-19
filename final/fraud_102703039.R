
require(caret)
require(rpart)
require(pROC)
require(unbalanced)


getRecall <- function(conf, target) {
    return(conf[target, target] / sum(conf[, target]))
}

getPrecision <- function(conf, target) {
    return(conf[target, target] / sum(conf[target,]))
}

getF1Score <- function(conf, target) {
    prec <- getPrecision(conf, target)
    reca <- getRecall(conf, target)
    return(2 * prec * reca / (prec + reca))
}


# read parameters
args = commandArgs(trailingOnly=TRUE)
if (length(args) > 1) {
    stop("USAGE: Rscript fraud_102703039.R [-o]", call.=FALSE)
}


# parse parameters
i <- 1
original <- FALSE
while(i <= length(args)) {
    if(args[i] == "-o"){
        original <- TRUE
    }else{
        stop(paste("Unknown flag", args[i]), call.=FALSE)
    }
    i <- i+1
}


# k-fold
n <- 5


# read input
input <- "creditcard.csv"
data <- read.csv(input, header=T)
print("Original dimension:")
print(dim(data))
print("Original class:")
print(table(data$Class))


# balance data
b <- ubSMOTE(X=data[, -31], Y = as.factor(data$Class),
             perc.over=300, perc.under=700,  verbose=TRUE)
data <- cbind(b$X, Class=b$Y)
print("After balanced, dimension:")
print(dim(data))
print("After balanced, class:")
print(table(data$Class))


# -o: drop columns or not
if (original == FALSE) {
    # drop unimportant columns
    drop_col <- c(1, 14, 16, 23, 24, 25, 26, 27)
    data <- data[, -drop_col]
    print("After drop some columns, dimension:")
    print(dim(data))
}


# divide data into several groups
data$div <- sample(1:n, nrow(data), replace=TRUE)
folds <- list()
for (i in c(1:n)) {
    folds[[i]] <- subset(data, div %in% c(i))
    folds[[i]]$div <- NULL
}
data$div <- NULL

# init auc result list
auc <- c()
confM <- list()
rec <- c()
prec <- c()
f1 <- c()


# n-folds cross-validation
for (i in c(1:n)) {
    print(paste("Implement Cross-validation: ", i))
    # testing part
    testIndex <- i
    test <- folds[[testIndex]]

    # training part
    train <- data.frame()
    for (j in c(1:n)) {
        if (j != testIndex) {
            train <- rbind(train, folds[[j]])
        }
    }


    # rpart
    ctrl <- rpart.control(maxdepth=5)
    rp <- rpart(Class ~ ., train, control=ctrl)

    # predict class to look up confusion matrix
    trainRes_class <- predict(rp, train[, -c(ncol(data)) ], type="class")
    conf <- table(prediction=trainRes_class, reference=train[, ncol(data)])
    print(conf)
    confM[[i]] <- conf
    rec <- c(rec, getRecall(conf, 1))
    prec <- c(prec, getPrecision(conf, 1))
    f1 <- c(f1, getF1Score(conf, 1))


    # predict probability to look up AUC
    trainRes_prob <- predict(rp, train[, -c(ncol(data)) ], type="prob")
    auc <- c(auc, auc(train[, ncol(data)], trainRes_prob[,2]))
}


resTable <- data.frame(methods=c("1st validation", "2nd validation",
                                 "3rd validation", "4th validation",
                                 "5th validation"),
                       recall=rec,
                       precision=prec,
                       F1=f1,
                       AUC=auc)


# print result
print("Result:")
print(paste(1:n, ": ", auc))
print(paste("Average AUC:", mean(auc)))
print(confM)
print(resTable)
