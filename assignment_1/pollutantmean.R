pollutantmean <- function(directory, pollutant, id=1:332){
    ## "directory" is a character vector of length 1 indicating 
    ## the location of the CSV files
    
    ## "pollutant" is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the mean;
    ## either "sulfate" or "nitrate"
    
    ## "id" is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors list
    ## in the 'id' vector (ignoring NA values)
    library(data.table)
    values <- numeric(0)    # variable for pollutant values
    files <- sort(dir(directory))[id]
    for (i in seq_along(id)) {
        filename <- file.path(directory, files[i], fsep=.Platform$file.sep)
        x <- fread(file=filename, sep=",", select=pollutant)
        x <- x[[pollutant]]
        x <- x[!is.na(x)]
        values <- append(values, x)
        }
    mean(values, na.rm=TRUE)
    }