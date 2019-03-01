corr <- function(directory, threshold=0) {
    ## "directory" is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## "threshold" is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all variables)
    ## required to compute the correlation between nitrate and
    ## sulfate; the default is 0
    
    ## Returns a numeric vector of correlations
    library(data.table)
    output <- numeric()
    files <- sort(dir(directory))
    for (i in seq_along(files)) {
        if (complete(directory, i)$nobs[1] > threshold) {
            filename = file.path(directory, files[i], fsep=.Platform$file.sep)
            x <- fread(file=filename, sep=",", select=c("nitrate", "sulfate"))
            x <- x[complete.cases(x), ]
            output[i] = cor(x$nitrate, x$sulfate)
        }
    }
    output[!is.na(output)]
}