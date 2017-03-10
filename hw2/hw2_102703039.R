########################
# homework2
# GOAL: Get the max value from several tables and output new table.
# DATE: 17/03/11
########################

args = commandArgs(trailingOnly=TRUE)
input_files <- c()
output_file <- c()

if (length(args) < 4) {
    stop("USAGE: Rscript hw2_102703039.R -files [input-files] -out [result-file]", call.=FALSE)
} else {
    # get input/output file
    for (i in c(1:length(args))) {
        if (args[i] == '-files') {
            j <- i+1
            while (j < length(args)+1 && args[j] != '-out') {
                input_files <- append(input_files, args[j])
                j <- j + 1
            }
        }
        else if (args[i] == '-out') {
            output_file <- args[i+1]
        }
    }
    if (is.null(input_files) || is.null(output_file)) {
        stop("USAGE: Rscript hw2_102703039.R -files [input-files] -out [result-file]", call.=FALSE)
    }
    for (input in input_files) {
        if (!file.exists(input)) {
            stop("ERROR: No such input file, please check it.")
        }
    }
}

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

# define the function getting the index of the max value
getMaxIndex <- function (data) {
    index <- 1
    for (i in c(2:length(data))) {
        if (data[i] > data[index]) {
            index <- i
        }
    }
    return(index)
}

# initialize result list
setName <- c()
maxWeight <- c()
maxHeight <- c()

for (input in input_files) {
    # read file
    data <- read.csv(input, header=TRUE, sep=',')

    # accumulate max values
    setName <- append(setName, sub('.csv$', '', input))
    maxWeight <- append(maxWeight, getMax(data[,'weight']))
    maxHeight <- append(maxHeight, getMax(data[,'height']))
}

# conclude the result
setName <- append(setName, 'max')
maxWeight <- append(maxWeight, sub('.csv$', '', input_files[getMaxIndex(maxWeight)]))
maxHeight <- append(maxHeight, sub('.csv$', '', input_files[getMaxIndex(maxHeight)]))

set <- c(setName)
weight <- c(maxWeight)
height <- c(maxHeight)

data <- data.frame(set, weight, height)

# write file
write.csv(data, file=output_file, row.names=FALSE, quote=FALSE)

