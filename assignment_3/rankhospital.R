rankhospital <- function(state, outcome, num = "best") {
    library(data.table)
    ## Read outcome data
    data <- fread("outcome-of-care-measures.csv", select=c(2, 7, 11, 17, 23))
    names(data) <- c("name", "state", "heart attack", "heart failure", "pneumonia")
    
    ##Check that state and outcome are valid
    if (!any(state == data$state)) stop("invalid state")
    if (!any(outcome == names(data)[3:5])) stop("invalid outcome")
    
    ## Return hospital name in that state with the given rank 30-day death rate
    s <- data$state == state
    data <- data[s, ]   # selecting data for the state
    data[[outcome]] <- suppressWarnings(as.numeric(data[[outcome]]))  # converting mortality rates to numeric
    data <- data[!is.na(data[[outcome]]), ]  # getting rid of NAs
    data <- data[order(data[[outcome]], data$name)]  # sorting data first by mortality, then by hospital name
    if (num == "best") return(data$name[1])
    if (num == "worst") return(data$name[nrow(data)])
    data$name[num]
}