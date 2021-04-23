library(dplyr)
library(xlsx)
library(XML)
library(data.table)
library(httr)
library(Hmisc)

## Set directory
dir <- "//filer5/Hehl_P/DataScienceTrainingProgram/Datasciencecoursera"
setwd(dir)

## Download file
#URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
#download.file(URL, destfile = "./data/project.")

## Read in all tables
test.set <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
labels.test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
id.test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
train.set <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
labels.train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
id.train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
activity.labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Add columns for subject ID and labels for activities for each dataset
test.set2 <- cbind(id.test, labels.test, test.set)
train.set2 <- cbind(id.train, labels.train, train.set)

## (#1) Merge Training and Test datasets into one dataset
merged <- rbind(train.set2, test.set2)

## Add names for activity variables (#4: Appropriately labels the data set with descriptive variable names. )
names <- read.table("./data/UCI HAR Dataset/features.txt")
names <- names[,2]
names(merged)[c(3:563)] <- names

## Add names for Subject/ID and Activity Type
names(merged)[1] <- "SubjectID"
names(merged)[2] <- "ActivityID"
names(activity.labels)[1] <- "ActivityID"
names(activity.labels)[2] <- "ActivityLabel"

## Merge activity labels by activity ID (#3 Uses descriptive activity names to name the activities in the data set)
merged2 <- merge(activity.labels, merged, by="ActivityID")

## Get only columns with "mean()" or "std()" (#2: Extracts only the measurements on the mean and standard deviation for each measurement.)
merged3 <- select(merged2, colnames(merged2)[grepl("SubjectID|ActivityLabel|mean()|std()",colnames(merged2))])

## #5 creates a second, independent tidy data set with the average of each variable for each activity and each subject.
merged4 <- group_by(merged3, ActivityLabel, SubjectID)
means_all <- summarize_all(merged4, funs(mean), na.rm=TRUE)