rankall <- function(outcome, num = "best") {
    find_num <- function(object, num) {
        if (num == "best") return(object[1, 1])
        if (num == "worst") return(object[nrow(object), 1])
        object[num, 1]
    }
    library(data.table)
    ## Read outcome data
    data <- fread("outcome-of-care-measures.csv", select=c(2, 7, 11, 17, 23))
    names(data) <- c("name", "state", "heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    if (!any(outcome == names(data)[3:5])) stop("invalid outcome")
    
    ## For each state, find the hospital of the given rank
    data[[outcome]] <- suppressWarnings(as.numeric(data[[outcome]]))
    data <- data[!is.na(data[[outcome]]), ]
    by_state <- lapply(split(data, data$state), function(x) x[order(x[[outcome]], x$name)])
    ranked <- lapply(by_state, find_num, num)
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    data.frame(hospital=sapply(ranked, function(x) as.character(x[1])), state=names(ranked))
}