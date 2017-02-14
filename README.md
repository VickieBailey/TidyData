## TidyData
Getting and Cleaning Data Course Project

## Synopsis
This is the final peer-graded project for the Getting and Cleaning Data Course through
Cousera and John Hopkins University.
Complete information about the project can be found here:
* https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

I used RStudio Version 1.0.136 with R version 3.3.2 and the data.table package.

## Here Goes...

Basically, I have been tasked with creating one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable
   for each activity and each subject.

This project uses the data from the Human Activity Recognition Using Smartphones Dataset. A summary of
the experiment is available at the following website:
* http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names

The data for this project can be found at:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This file contains a zip file with the UCI HAR Dataset file which contains a file for train data,
a file for test data, and four text documents.

The project requested the mean and standard deviation information for each feature so I only downloaded
the following information which I included in the code.

  * From the UCI HAR Data main file: activity_labels.txt, and features.txt.
  * From inside the test file: subject_test, X_test.txt, and y_test.txt.
  * From inside the train file: subject_train, X_train.txt, and y_train.text.
 
A Code Book is provided to provide information about the variables and my process.

More information about this Human Activity Recognition dataset can be found at
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##Enjoy!
