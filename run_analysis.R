## Vickie Bailey
## Getting and Cleaning Data
## Week 4 Project
## February 13, 2017


## Set working directory for project with setwd()
## Open library for required packages.
library(data.table)

## Check for and create directory for data.
if(!file.exists("./data")){
    dir.create("./data")
}

## Website for data.
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Check if the zip file exists for our project.
if(!file.exists("./data/Dataset.zip")) {
    download.file(url, destfile = "./data/Dataset.zip")
    dateDownloaded <- date()
}

## Check if UCI HAR Dataset exists. If not, unzip.
if(!file.exists("./data/UCI HAR Dataset")) {
    unzip(zipfile = "./data/Dataset.zip", exdir = "./data") 
}   

## Look inside directory to see what is inside. 
list.files("./data/UCI HAR Dataset")
list.files("./data/UCI HAR Dataset/test")
list.files("./data/UCI HAR Dataset/train")

## Two folders, "test" and "train", contain data to be used for this project.
## Read in the data.
testset <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt",
                      na.strings = "N/A", stringsAsFactors = FALSE)
trainset <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt",
                       na.strings = "N/A", stringsAsFactors = FALSE)

## Read in the activity label files for both test and train sets.
## These are long sets.
testlabels <- read.table(file = "./data/UCI HAR Dataset/test/y_test.txt",
                         na.strings = "N/A", stringsAsFactors = FALSE)
trainlabels <- read.table(file = "./data/UCI HAR Dataset/train/y_train.txt",
                          na.strings = "N/A", stringsAsFactors = FALSE)

## Read in subject identifier data. These are long data sets.
testsub <- read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt",
                      na.strings = "N/A", stringsAsFactors = FALSE)
trainsub <- read.table(file = "./data/UCI HAR Dataset/train/subject_train.txt",
                       na.strings = "N/A", stringsAsFactors = FALSE)

## Read in activity labels and define columns.
## This is a small data frame with the identifying number as activityid
## and the activity name.
activity <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt",
                            na.strings = "N/A", stringsAsFactors = FALSE)
colnames(activity) <- c("activityID", "activityname")

## Read in the long data frame with all of the measured feature names.
features <- read.table(file = "./data/UCI HAR Dataset/features.txt",
                       na.strings = "N/A", stringsAsFactors = FALSE)

## Step 1:
## Merge the training and the test sets to create one data set.
combinedset <- rbind(trainset, testset)
## Transpose the 2nd column of features into the column names
## for combinedset data frame.
colnames(combinedset) <- t(features[,2])

##Combine the data frames with the activity labels for training and testing.
activitylabels <- rbind(trainlabels, testlabels)
## Match the column name for this data frame with the identifying number column
## in activity. This will allow us to merge later on that value.
colnames(activitylabels) <- "activityID"

## Combine the data frames for the training and testing subjects.
subjects <- rbind(trainsub, testsub)
colnames(subjects) <- "subjectID"

## Step 2:
## Extract only the measurements on the mean and standard deviation
## for each measurement.
## Use grepl on the combinedset data frame to subset the columns to
## mean and standard deviations features only.
## There are two features that included "mean()" - mean() and meanFreq().
## I excluded the meanFreq() since according to the features_info.txt
## it is the weighted average of the frequency components to obtain
## a mean frequency.
combmeanstd <- combinedset[,(grepl("^mean$", names(combinedset)) |
                                 grepl("std", names(combinedset)))]

## Gather up the subjects, combined mean and standard deviation,
## and activity labels data frames in order to unite all data into a
## large data frame.
## Column bind the three dataframes to create large dataframe.
united <- cbind(subjects, activitylabels, combmeanstd)

## Step 3:
## Uses descriptive activity names to name the activities in the data set.
## The names provided are descriptive so they were added to the data frame.
completed <- merge(activity, united, by = "activityID", sort = FALSE)

## Remove column with activity identifying number and rearrange so subject
## is the first column.
completed <- completed[,c(3,2,4:ncol(completed))]

## Step 4:
## Appropriately labels the data set with descriptive variable names.
## This was done as I went along.
## The feature names were kept due to the fact that they are descriptive
## and the code book is provided.

## Step 5:
## From the data set in step 4, creates a second independent tidy data set
## with the average of each variable for each activity and each subject.
tidydata <- aggregate(. ~ activityname + subjectID, completed, mean)

## Rearrange the columns so the subjectID is 1st followed by activityname.
tidydata <- tidydata[, c(2,1,3:ncol(tidydata))]

## Write .txt file.
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
