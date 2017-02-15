# Code Book

I  have split this code book into two parts: Study Design and Code Book.

## Study Design

The data for this project is obtained by a link posted on the [Getting and Cleaning Data Course Project page](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) for the John Hopkins University Coursera.
The link is for the zip file with the [Human Activity Recognition Using Smartphones Data Set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) from the University of California, Irvine campus where there is a Machine Learning Repository.

#### Data Background
Based on information from the [repository's website] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the data was collected through experiments with subjects who were wearing a Samsung Galaxy S II smartphone on their waist.
  * Subjects: 30 volunteers ages 19-48 given ID numbers 1 through 30; split into 2 groups 70% in training and 30% in testing
  * Monitored Activities: laying, sitting, standing, walking, walking downstairs, and walking upstairs
  * Number of observations for all activities: 10299
  * Two embedded sensor tools were utilized: accelerometer and gyroscope
  * Features: 561 time and frequency domain variables
  
#### My Process
I am to perform a tidying of the data that is provided. Some of the data is in very raw form and will not be utilized for this project since we are told to extract the mean and standard deviation data.

Before downloading anything to my computer, I looked at the text file and readme's from the repository's website: [Data Folder](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/). A list of files that are in the zip file showed a total of 28 text files although not all files are listed explicitly due to the repetitive nature of recording and naming off the x, y, and z axes.

  * 1: Opened RStudio, set working directory, and called the library function to bring in data.table package.
 
  * 2: Check for / or create a data folder in the working directory.
 
  * 3: Assign a variable for the url. Then perform a check for the required zip file using an if statement.
  
  * 4: Use if statement to see if file "UCI HAR Dataset" exists in data file. If not, then unzip.
  
  * 5: Use list.files to look around to make sure what was downloaded is what was expected. Since the assignment deals variables with mean and standard deviation, I did not bring in the data from the Inertial Signals folders as that was the really raw data from which the mean and standard deviation features had been drawn.
  
  * 6: At this point, I double checked the information from the repository's website before reading in the data. I chose to read in the data as couplets of train and test since we had to combine them together at some point. I still saved each text file as its own dataframe as it was read into RStudio.
  
Use read.table to bring in text files as data frames in the following order with na.strings = "N/A", stringsAsFactors = FALSE
      * X_test.txt saved as testset dataframe and X_train.txt saved as trainset dataframe - These contain the measured values for the 561 time and frequency variables.
      * y_test.txt saved as testlabels and y_train.txt saved as trainlabels - These contain the activity numeric identification labels as observations were collected.
      * subject_test.txt saved as testsub and subject_train.txt saved as trainsub - These contain the subject numeric identifying labels as observations were collected.
      
  * 7: Two text files are singlets. Use read.table to bring in text files as data frames in the following order with na.strings = "N/A", stringsAsFactors = FALSE
    * activity_labels.txt read in and saved as activity dataframe with dimensions [6 2]. I named the columns "activityID" and "activityname". The "activityID" was decided upon as a way to connect the labels with the actual name of the activity.
    * features.txt which was read in and saved as features dataframe with two columns which I left unchanged.
    
Here is where I sat down with pencil and paper and scratched my head for awhile. I opened up the features_info.txt file in the UCI HAR Dataset. There were so many ways to attack this data - should I melt it or keep it wide? I opted for wide.

#### Instructions from the Project

* Step 1: Merge the training and the test sets to create one data set.
I looked at the dimensions of the dataframes to consider how they might fit together. The trainset and testset dataframes each have 561 columns while the features dataframe has 561 rows. So I did a rowbind on the trainset and testset dataframes, respectively and then transposed the 2nd column of the features dataframe to become the column names for the new combinedset dataframe. The dimensions of the new combinedset dataframe is now [10299, 561] that contains the 561 features variable names and 10299 observation rows.

```{r }
combinedset <- rbind(trainset, testset)
## Transpose the 2nd column of features into the column names
## for combinedset data frame.
colnames(combinedset) <- t(features[,2])
```

I used rowbind to combine the trainlabels and testlabels dataframes to create activitylabels dataframe whith dimensions [10299, 1]. I changed the column name to "activityID" so I could use this column to connect with the activity dataframe's "activityID" corresponding to the actual names of the activities performed.
  
Similarly, rowbinding the trainsub and testsub dataframes to the subjects dataframe with dimensions [10299, 1] to represent the 10299 observations by volunteer subject identifying number.

* Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

I almost combined by columns at this point the three dataframes - combinedset, activitylabels, and subjects. But as I read through the instructions, I thought it was easier to extract the mean() and std() - or standard deviation - from the feature columns without the extra data.

I used grepl on the combinedset data frame to subset the columns to mean and standard deviations features only. The result was stored as combmeanstd dataframe.

```{r }
combmeanstd <- combinedset[,(grepl("^mean$", names(combinedset)) |
                                 grepl("std", names(combinedset)))]
```

Side note - there were two uses of mean in the features - mean() and meanFreq(). I chose to exclude the meanFreq(); since according to the features_info.txt, it represents the weighted average of the frequency components to obtain a mean frequency. The variables containing meanFreq() can easily be added back in to subset if necessary or desired.

I then gathered up my three dataframes - subjects, activitylabels, and combmeanstd - to column bind them as one. I stored this dataframe as united.

* Step 3: Uses descriptive activity names to name the activities in the data set. The names provided in the activity data frame as laying, sitting, standing, walking, walking_downstairs, and walking_upstairs are descriptive enough for our uses. I used merge to complete this task. I put the activity dataframe first so to prepend the names and then merge with the united dataframe with sort set to FALSE. I named this dataframe completed although I did remove column one which was the activity numeric identifying column rearrange the second and third columns so the subjectID was listed first. Followed by the activity name and then the variables.

* Step 4: Appropriately labels the data set with descriptive variable names.

I did this as we went along. Changing the variable identifiers from what was listed in the features dataframe seemed unnecessary. I have provided the meaning for the names as was provided in the features_info.text in the Code Book section that follows.

* Step 5: From the data in step 4, creates a second independent tidy data set with the average of each variable for each activity and each subject.

This needs to be saved as a .txt file and then uploaded on the course site. So I used the aggregate function.

```{r }
tidydata <- aggregate(. ~ activityname + subjectID, completed, mean)
```

Then I rearranged the columns so the subjectID is followed by activityname and then the mean and standard deviation feature variables before performing the write.table function.


## Code Book

For my final tidydata.txt columns
Col 1 - Subject Identification number - a value 1 to 30
Col 2 - The name of the activity performed by the subject. There are 6 activities per subject.
Col 3-35 - Represent the subsetted feature variables containing mean() and std().

I used the [README.txt](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.names), features_info.txt, and [UCI Human Activity Recognition website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#) to derive the information for the features variables.

The following excerpt is from features_info.txt which can be found in Data folder from the [UCI Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."

Ex feature breakdown:
tBodyGyro-std()-Z is the feature variable that represents the time in seconds 
t time as measured in seconds
Body is the body motion
Gyro represents the signal came from the smartphones embedded gyroscope as it picks up the angular velocity measured in radians/second
std() - standard deviation
Z - along the Z axis
 
