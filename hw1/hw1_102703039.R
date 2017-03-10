########################
# homework1
# GOAL: Get the max value and output new table.
# DATE: 17/02/23
########################

args = commandArgs(trailingOnly=TRUE)
input_file <- ''
output_file <- ''

if (length(args) < 4) {
    stop("USAGE: Rscript hw1_102703039.R -files [input-file] -out [result-file]", call.=FALSE)
} else {
    # get input/output file
    for (i in c(1:length(args))) {
        if (args[i] == '-files') {
            input_file <- args[i+1]
        }
        else if (args[i] == '-out') {
            output_file <- args[i+1]
        }
    }
    if (input_file == '' || output_file == '') {
        stop("USAGE: Rscript hw1_102703039.R -files [input-file] -out [result-file]", call.=FALSE)
    }
    if (!file.exists(input_file)) {
        stop("ERROR: No such input file, please check it.")
    }
}

# read file
data <- read.csv(input_file, header=TRUE, sep=',')

# define the function getting the max value
getMax <- function (data) {
    max <- data[1]
    for (i in c(2:length(data))) {
        if (data[i] > max) {
            max <- data[i]
        }
    }
    return(round(max, 2))
}

setName <- sub('.csv$', '', input_file)
maxWeight <- getMax(data[,'weight'])
maxHeight <- getMax(data[,'height'])

set <- c(setName)
weight <- c(maxWeight)
height <- c(maxHeight)

data <- data.frame(set, weight, height)

# write file
write.csv(data, file=output_file, row.names=FALSE, quote=FALSE)

