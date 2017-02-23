########################
# homework1 example
########################

args = commandArgs(trailingOnly=TRUE)
input_file <- ''
output_file <- ''

if (length(args) < 4) {
    stop("USAGE: Rscript hw1_exam.R -files [input-file] -out [result-file]", call.=FALSE)
} else {
    for (i in c(1:length(args))) {
        if (args[i] == '-files') {
            input_file = args[i+1]
        }
        else if (args[i] == '-out') {
            output_file = args[i+1]
        }
    }
    if (input_file == '' || output_file == '') {
        stop("USAGE: Rscript hw1_exam.R -files input -out result", call.=FALSE)
    }
}

data <- read.table(input_file, header=TRUE, sep=',')

getMax <- function (data) {
    max <- data[1]
    for (i in 2:length(data)) {
        if (data[i] > max) {
            max <- data[i]
        }
    }
    return(round(max, 2))
}

maxWeight <- getMax(data[,2])
maxHeight <- getMax(data[,3])

print(maxWeight)
print(maxHeight)
