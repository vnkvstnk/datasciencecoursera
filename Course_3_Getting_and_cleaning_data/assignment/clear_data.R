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

# Read test dataset
activity_test <- fread(path_to_ytest) %>% as_tibble()
subject_test <- fread(path_to_subj_test) %>% as_tibble()
x_test <- fread(path_to_xtest, select = foi) %>% as_tibble() %>%
    setNames(names) %>% mutate(activity = activity_test$V1, subject = subject_test$V1, set = "TEST")

# Read train dataset
activity_train <- fread(path_to_ytrain) %>% as_tibble()
subject_train <- fread(path_to_subj_train) %>% as_tibble()
x_train <- fread(path_to_xtrain, select = foi) %>% as_tibble() %>%
    setNames(names) %>% mutate(activity = activity_train$V1, subject = subject_train$V1, set = "TRAIN")

# Merging datasets
data <- bind_rows(x_test, x_train) %>% select(set:tBodyAccMeanX) %>%
    mutate_at(c("set", "subject", "activity"), list(factor))
data$activity <- recode_factor(data$activity, "1"="WALKING", "2"="WALKING_UP", "3"="WALKING_DOWN",
                               "4"="SITTING", "5"="STANDING", "6"="LAYING")
