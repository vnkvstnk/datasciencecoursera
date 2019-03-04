# Loading packages
library(dplyr)
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
foi <- which(grepl("mean\\(\\)|std\\(\\)|meanfreq\\(\\)", tolower(features$V2)))   # features of interest

# Reading files
y_test      <- fread(path_to_ytest) %>% as_tibble()
subj_test   <- fread(path_to_subj_test) %>% as_tibble()
x_test      <- fread(path_to_xtest, select = foi) %>% as_tibble() %>%
               setNames(features$V2[foi]) %>% mutate(act = y_test$V1, sub = subj_test$V1, set = "test")

y_train     <- fread(path_to_ytrain) %>% as_tibble()
subj_train  <- fread(path_to_subj_train) %>% as_tibble()
x_train     <- fread(path_to_xtrain, select = foi) %>% as_tibble() %>%
               setNames(features$V2[foi]) %>% mutate(act = y_train$V1, sub = subj_train$V1, set = "train")

data <- bind_rows(x_test, x_train)


# Column names contain variables, lets try and fix this

# Gather columns that shoud be variables
test_data <- gather(data, all_vars, val, -act, -sub, -set)

# Now let's try and separate them in the following variables:
# domain: time or frequency
# dir: X, Y or Z
# sensor: Acc or Gyro
# acceleration: Body or Gravity
# dontknow: mean or std

# In order to separate variables we need to insert special symbols in the names.
# But we should do it after reading features (so that we operate on fewer number of columns) 
test_data$all_vars <- gsub("Body", "=Body=", test_data$all_vars)
test_data$all_vars <- gsub("Gravity", "=Gravity=", test_data$all_vars)