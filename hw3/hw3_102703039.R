########################
# homework3
# GOAL: Calculate sensitivity, specificity, F1 score and AUC for several input files.
# DATE: 17/04/20
########################

query_func <- function(query_m, i)
{
    if (query_m == "male"){
        which.max(i)
    }
    else if (query_m == "female") {
        which.max(i)
    } else {
        stop(paste("ERROR: unknown query function", query_m))
    }
}

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

getAUC <- function(scores, refs) {
    return(attributes(performance(prediction(scores, refs), "auc"))$y.values[[1]])
}

getSecondIndex <- function (vec) {
    print(vec)
    len <- length(vec)
    return(as.integer(sapply(sort(vec, index.return=TRUE), `[`, length(vec)-2+1)['ix']))
}

buildContingencyTable <- function(index_1, index_2, target, oppo, files, names) {
    d <- read.table(files[index_1], header=T, sep=",")
    list_1 <- d$prediction
    d <- read.table(files[index_2], header=T, sep=",")
    list_2 <- d$prediction
    tag1 <- names[index_1]
    tag2 <- names[index_2]
    return(table(tag1=list_1, tag2=list_2))
}

# read parameters
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
    stop("USAGE: Rscript hw3_102703039.R --target male/female --files file1 file2 ... filen –-out out.csv", call.=FALSE)
}

library("ROCR")
# parse parameters
i <- 1
while(i < length(args)) {
    if(args[i] == "--target"){
        query_m <- args[i+1]
        if (query_m == "male")
            oppo <- "female"
        else
            oppo <- "male"
        i <- i+1
    }else if(args[i] == "--files"){
        j <- grep("-", c(args[(i+1):length(args)], "-"))[1]
        files <- args[(i+1):(i+j-1)]
        i <- i+j-1
    }else if(args[i] == "--out"){
        out_f <- args[i+1]
        i <- i+1
    }else{
        stop(paste("Unknown flag", args[i]), call.=FALSE)
    }
    i <- i+1
}

# print some logs
print("PROCESS")
print(paste("query mode :", query_m))
print(paste("output file:", out_f))
print(paste("files      :", files))

# init list
names <- c()
sens <- c()
spes <- c()
f1s <- c()
aucs <- c()

for(file in files)
{
    # read file
    name <- gsub(".csv", "", basename(file))
    d <- read.table(file, header=T, sep=",")
    names <- c(names, name)

    # calculate all data
    confMatrix <- getConfusionMatrix(d$prediction, d$reference)
    sen <- round(getSensitivity(confMatrix, query_m, oppo), 2)
    spe <- round(getSpecificity(confMatrix, query_m, oppo), 2)
    f1 <- round(getF1Score(confMatrix, query_m, oppo), 2)
    auc <- round(getAUC(d$pred.score, d$reference), 2)

    # append result
    sens <- c(sens, sen)
    spes <- c(spes, spe)
    f1s <- c(f1s, f1)
    aucs <- c(aucs, auc)
}

# find first method and second method
firstIndex <- query_func(query_m, f1s)
secondIndex <- getSecondIndex(f1s)

# build contingency table
contTable <- buildContingencyTable(firstIndex, secondIndex, query_m, oppo, files, names)

# calculate p-value
p_value <- fisher.test(contTable)['p.value']

# conclude the result
out_data <- data.frame(method=names, sensitivity=sens, specificity=spes, F1=f1s, AUC=aucs, stringsAsFactors = F)
print(out_data)
index <- sapply(out_data[, c("sensitivity", "specificity", "F1", "AUC")], query_func, query_m=query_m)
out_data <- rbind(out_data, c("highest", names[index]))

# if p < 0.05, mark it
if (p_value < 0.05) {
    out_data[length(files)+1,"F1"] <- paste(out_data[length(files)+1,"F1"], "*", sep="")
}

# output file
write.table(out_data, file=out_f, row.names=F, quote=F, sep=",")
