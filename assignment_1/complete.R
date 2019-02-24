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
    for (i in id) {
        if (i < 10){
            file_ <- paste("00", i, ".csv", sep="")
        } else if (i < 100 & i >=10) {
            file_ <- paste("0", i, ".csv", sep="")
        } else {
            file_ <- paste(i, ".csv", sep="")
        }
        filename <- file.path(directory, file_, fsep=.Platform$file.sep)
        x <- fread(file=filename, sep=",", select=c("nitrate", "sulfate"), data.table=FALSE)
        df <- rbind(df, c(i, sum(complete.cases(x))))
    }
    df
}