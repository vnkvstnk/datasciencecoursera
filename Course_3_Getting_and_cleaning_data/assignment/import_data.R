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

# Reading files
features    <- fread(path_to_features)
x_test      <- fread(path_to_xtest)
y_test      <- fread(path_to_ytest)
subj_test   <- fread(path_to_subj_test)
x_train     <- fread(path_to_xtrain)
y_train     <- fread(path_to_ytrain)
subj_train  <- fread(path_to_subj_train)