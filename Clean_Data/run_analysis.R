# Peer-graded Assignment: Getting and Cleaning Data Course Project

# Download and unzip Data source: 
# install.packages("downloader")
library(downloader)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="dataset.zip", mode="wb")
unzip("dataset.zip", exdir = "./")

# Import 8 files and check dims
# 'activity_labels.txt'
# 'features.txt'
# 'train/X_train.txt': Training set.
# 'train/y_train.txt': Training labels.
# 'test/X_test.txt': Test set.
# 'test/y_test.txt': Test labels.
# 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
# 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

# 1. activitiy labels (corresponding to activity class code)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 

# 2. feature names = col/var names for training/test set
features <- read.table("UCI HAR Dataset/features.txt")

# 3. training set, 70% of population. adding column names
X_train_set <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[,2])

# 4. training activity labels
y_train_labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity") 

# 5. test set, 30% of population. adding column names
X_test_set <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[,2]) 

# 6. test activity labels
y_test_labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity") 

# 7. subject performing in training set
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject") 

# 8. subject performing in test set
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Follow assignment instructions:
# 1. Merge training and test set to create one data set

# 1a. combining subject, activity with respective training/test set
training_set <- cbind(subject_train, y_train_labels, X_train_set)
test_set <- cbind(subject_test, y_test_labels, X_test_set)

# 1b. combining training and test set
dataset_all <- rbind(training_set, test_set)


# 2. Extract only the measurements on the mean and standard deviation for each measurement

# 2a. find col names that include "std" or "mean"; keep subject and activity
col_mean_std <- c("subject","Activity",
                  grep("std", colnames(X_train_set), value = TRUE), 
                  grep("mean", colnames(X_train_set), value = TRUE))
# 2b. create subset with only these columns
subset <- dataset_all[,col_mean_std] 

# 3. Use descriptive activity names to name the activities in the dataset

# Option 1:
subset$Activity[subset$Activity == 1] <- as.character(activity_labels[1,2])
subset$Activity[subset$Activity == 2] <- as.character(activity_labels[2,2])
subset$Activity[subset$Activity == 3] <- as.character(activity_labels[3,2])
subset$Activity[subset$Activity == 4] <- as.character(activity_labels[4,2])
subset$Activity[subset$Activity == 5] <- as.character(activity_labels[5,2])
subset$Activity[subset$Activity == 6] <- as.character(activity_labels[6,2])

# Option 2:
subset$Activity_name[subset$Activity == 1] <- "WALKING"
subset$Activity_name[subset$Activity == 2] <- "WALKING_UPSTAIRS"
subset$Activity_name[subset$Activity == 3] <- "WALKING_DOWNSTAIRS"
subset$Activity_name[subset$Activity == 4] <- "SITTING"
subset$Activity_name[subset$Activity == 5] <- "STANDING"
subset$Activity_name[subset$Activity == 6] <- "LAYING"
# ====================== how to reduce lines of code? for loop?

# 4. Appropriately label data set with descriptive variable names.

# 5. take the average (mean) of variables in subset (step 4) grouped by subject and by activity. 

# Option 1 (col sequence not ideal):
result1 <- aggregate(. ~ Activity + subject, data = subset, FUN = 'mean')

# Option 2
library(plyr)
groupColumns = colnames(subset[,1:2])
dataColumns = colnames(subset[,-(1:2)])
result2 = ddply(subset, groupColumns, function(x) colMeans(x[dataColumns]))

result2$subject <- as.factor(result2$subject)
result2$Activity <- as.factor(result2$Activity)
str(result2)

install.packages("memisc")
library(memisc)
codebook(result2[,1:2])
