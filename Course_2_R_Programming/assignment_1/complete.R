complete <- function(directory, id=1:332) {
    ## "directory" is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## "id" is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Returns a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where "id" is the monitor ID number and "nobs" is the
    ## number of complete cases
    library(data.table)
    df <- data.frame(id=integer(), nobs=integer())  # data frame to fill
    files <- sort(dir(directory))[id]
    for (i in seq_along(id)) {
        filename <- file.path(directory, files[i], fsep=.Platform$file.sep)
        x <- fread(file=filename, sep=",", select=c("nitrate", "sulfate"))
        df[i, ] = c(id[i], sum(complete.cases(x)))
    }
    df
}