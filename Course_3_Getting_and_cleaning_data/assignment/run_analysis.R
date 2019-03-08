# Loading packages
library(dplyr)
library(tidyr)
library(data.table)

# Constructing paths to files
path_to_features    <- file.path("dataset", "features.txt")
path_to_xtest       <- file.path("dataset", "test", "X_test.txt")
path_to_ytest       <- file.path("dataset", "test", "y_test.txt")
path_to_subj_test   <- file.path("dataset", "test", "subject_test.txt")
path_to_xtrain      <- file.path("dataset", "train", "X_train.txt")
path_to_ytrain      <- file.path("dataset", "train", "y_train.txt")
path_to_subj_train  <- file.path("dataset", "train", "subject_train.txt")

# Reading variable names
features    <- fread(path_to_features)
foi <- which(grepl("mean\\(\\)|std\\(\\)", tolower(features$V2)))
names <- features$V2[foi]

# Removing hyphens and brackets from names
names <- gsub("-mean\\(\\)", "Mean", names) %>% gsub(pattern="-std\\(\\)", replacement="Std") %>%
    gsub(pattern="-", replacement = "")

# Importing activity and subject vectors for test and train sets
activity_test <- fread(path_to_ytest) %>% as_tibble()
subject_test <- fread(path_to_subj_test) %>% as_tibble()
activity_train <- fread(path_to_ytrain) %>% as_tibble()
subject_train <- fread(path_to_subj_train) %>% as_tibble()

# Importing test and train dataset, adding activity, subject and set variables
x_test <- fread(path_to_xtest, select = foi) %>% as_tibble() %>%
    setNames(names) %>% mutate(activity = activity_test$V1, subject = subject_test$V1, set = 0)
x_train <- fread(path_to_xtrain, select = foi) %>% as_tibble() %>%
    setNames(names) %>% mutate(activity = activity_train$V1, subject = subject_train$V1, set = 1)

# Merging datasets
data <- bind_rows(x_test, x_train) %>% select(set:tBodyAccMeanX) %>%
    group_by(subject, activity) %>%
    summarize_all(funs(mean))

# Give `activity` and `set` proper labels
data$set <- factor(data$set, labels = c("TEST", "TRAIN"))
data$activity <- factor(data$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Saving data
write.table(data, file = "./clean_data.txt", row.names = FALSE)
