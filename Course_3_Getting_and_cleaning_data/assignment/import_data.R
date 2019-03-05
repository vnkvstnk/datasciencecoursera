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

# Finding out column indicies that we want to import
features    <- fread(path_to_features)
foi <- which(grepl("mean\\(\\)|std\\(\\)", tolower(features$V2))) # features of interest
names <- features$V2[foi] %>% gsub(pattern="BodyBody",replacement="Body") %>%
         gsub(pattern="-",replacement="")

# Reading files
y_test      <- fread(path_to_ytest) %>% as_tibble()
subj_test   <- fread(path_to_subj_test) %>% as_tibble()
x_test      <- fread(path_to_xtest, select = foi) %>% as_tibble() %>%
               setNames(names) %>% mutate(act = y_test$V1, sub = subj_test$V1, set = "test")

y_train     <- fread(path_to_ytrain) %>% as_tibble()
subj_train  <- fread(path_to_subj_train) %>% as_tibble()
x_train     <- fread(path_to_xtrain, select = foi) %>% as_tibble() %>%
               setNames(names) %>% mutate(act = y_train$V1, sub = subj_train$V1, set = "train")

data <- bind_rows(x_test, x_train)

# Gather columns that shoud be variables
test_data <- gather(data, all_vars, val, -act, -sub, -set)

# Now let's try and separate them in the following variables:
test_data$all_vars <- gsub("^t", "t-", test_data$all_vars) %>%
    gsub(pattern = "^f", replacement = "f-")
test_data <- separate(test_data, all_vars, c("domain", "all_vars"), sep="-")

test_data$all_vars <- gsub("^Body", "b-", test_data$all_vars) %>%
    gsub(pattern = "^Gravity", replacement = "g-")
test_data <- separate(test_data, all_vars, c("component", "all_vars"), sep="-")

test_data$all_vars <- gsub("^Acc", "a-", test_data$all_vars) %>%
    gsub(pattern = "^Gyro", replacement = "g-")
test_data <- separate(test_data, all_vars, c("sensor", "all_vars"), sep="-")

test_data$all_vars <- gsub("^Jerk", "j-", test_data$all_vars)
test_data <- separate(test_data, all_vars, c("jerk", "all_vars"), sep="-", fill="left")

test_data$all_vars <- gsub("^Mag", "m-", test_data$all_vars)
test_data <- separate(test_data, all_vars, c("mag", "all_vars"), sep="-", fill="left")

test_data$all_vars <- gsub("X$", "-x", test_data$all_vars) %>%
    gsub(pattern = "Y$", replacement = "-y") %>% 
    gsub(pattern = "Z$", replacement = "-z")
test_data <- separate(test_data, all_vars, c("all_vars", "dim"), sep="-", fill="right") %>%
    separate(all_vars, c("type"), remove = TRUE, extra="drop")

test_data$dim <- factor(test_data$dim)
test_data$act <- factor(test_data$act)
test_data$sub <- factor(test_data$sub)
test_data$set <- factor(test_data$set)
test_data$domain <- factor(test_data$domain)
test_data$component <- factor(test_data$component)
test_data$sensor <- factor(test_data$sensor)
test_data$jerk <- factor(test_data$jerk)
test_data$mag <- factor(test_data$mag)
test_data$type <- factor(test_data$type)
