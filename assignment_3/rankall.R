rankall <- function(outcome, num = "best") {
    library(data.table)
    ## Read outcome data
    data <- fread("outcome-of-care-measures.csv", select=c(2, 7, 11, 17, 23))
    names(data) <- c("name", "state", "heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    if (!any(state == data$state)) stop("invalid state")
    if (!any(outcome == names(data)[3:5])) stop("invalid outcome")
    
    ## For each state, find the hospital of the given rank
    data$state <- as.factor(data$state)
    data[[outcome]] <- suppressWarnings(as.numeric(data[[outcome]]))
    data <- data[!is.na(data[[outcome]]), ]
    by_state <- split(data, data$state)
    by_state <- lapply(by_state, function(x) x[order(x[[outcome]], x$name)])
    by_state <- lapply(by_state, function(x) x[num, c(1, 2)])
    
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    ans <- data.frame(hospital=character(), state=character())
    for (i in seq_along(by_state)) {
        if (num == "best") num <- 1
        if (num == "worst") num <- nrow(by_state[i])
        
        ans[i, ] = c(by_state[[i]]$name[num], names_[i])
    }
    ans
}