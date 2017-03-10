# The code here requires reshape2 and dplyr package. Check and install it

if (!"dplyr" %in% installed.packages()){
  install.packages("dplyr")
} 
library(dplyr)

if (!"reshape2" %in% installed.packages()){
  install.packages("reshape2")
} 
library(reshape2)

# The code here assumes that the dataset has been downloaded from the 
# URL and unzipped in folder UCI HAR Dataset. Followng is the folder 
# structure - 
# UCI HAR Dataset
# |_activity_labels.txt
# |_features.txt
# |_features_info.txt
# |_README.txt
# |_test
# |  |__subject_test.txt
# |  |__x_test.txt
# |  |__y_test.txt
# |  
# |_train
#    |__subject_train.txt
#    |__x_train.txt
#    |__y_train.txt


# Obtain the dataset and unzip it so that the above folder structure 
# is created
datasetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFileName <- "UCI HAR Dataset.zip"

# This should download the file from internet and create the above 
# mentioned folder structure with data
if(!file.exists(destFileName)){
  download.file(datasetUrl, destFileName, mode = "wb")

}

if(file.exists(destFileName)){
  unzip(destFileName)
}

currentDir <- getwd()
setwd("./UCI HAR Dataset")

# Two studies - TEST and TRAIN
studyType <- factor(c("TEST", "TRAIN"))

# Raw data for the 9 test subjects each row has 561 numeric obsevations 
# corresponding to the 561 features as mentioned in the features.txt. 
# This file has 2947 rows
testds <- read.table("test/X_test.txt")

# Raw data for one of the 6 activities being carried out as per 
# activity_labels.txt - This file has 2947 rows corresponding to the 2947 
# observations in x_test.txt
testAct <- readLines("test/y_test.txt")

# Add a new column to the dataset to link activity observations to activity 
# being carried out
testds$Activity <- testAct

# Raw data for one of the 9 subjects out of a total of 30 subjects - This file
# has 2947 rows corresponding to the 2947 observations in x_test.txt
testSubject <- readLines("test/subject_test.txt")

# Add a new column to the dataset to link activity observations to the subject 
# who carried out the activity
testds$Subject <- testSubject

# label all the test data observations using a factor TEST so that the merged 
# dataset of test + train can be filtered
testds$StudyType <- studyType[1]


# Repeat the previous steps for training data
# Raw data for the 21 test subjects each row has 561 numeric obsevations 
# corresponding to the 561 features as mentioned in the features.txt. 
# This file has 7352 rows
trainds <- read.table("train/X_train.txt")

# Raw data for one of the 6 activities being carried out as per 
# activity_labels.txt - This file has 7352 rows corresponding to the 7352 
# observations in x_train.txt
trainAct <- readLines("train/y_train.txt")

# Add a new column to the dataset to link activity observations to activity 
# being carried out
trainds$Activity <- trainAct

# Raw data for one of the 9 subjects out of a total of 30 subjects - This file
# has 2947 rows corresponding to the 2947 observations in x_test.txt
trainSubject <- readLines("train/subject_train.txt")

# Add a new column to the dataset to link activity observations to the subject 
# who carried out the activity
trainds$Subject <- trainSubject

# label all the train data observations using a factor TRAIN so that the merged
# dataset of test + train can be filtered
trainds$StudyType <- studyType[2]

# Objective 1
# Merge the training and test data
mergedDs <- rbind(trainds, testds)

# Objective 4 Appropriately label the data set
# fix the column naming
# Raw Column headings for the 561 varibles contained in traing and test 
# files - X_test.txt
features <- readLines("features.txt")

features <- c(features,"Activity", "Subject", "StudyType")

# Not Removing the leading numbers as the band energy columns are 
# duplicate and it is not possible to disambiguate them without 
# this number
# features <- sub("^[0-9]* ","", features)

# Replace () with ""
features <- sub("\\(\\)","", features)

# Set the cleaned names
names(mergedDs) <- features

# Objective 2 - Extract only the measurements on the mean and standard 
# deviation for each measurement

meanStdCols <- mergedDs[ , grepl("mean|std",names(mergedDs))]

# Objective 3 Give Descriptive activity names
# Apply Factors to the Activity Type so that instead of 1,2,3,4,5,6 it shows the 
# actual activity e.g. WALKING, SITTING, STANDING

actLabels <- read.table("activity_labels.txt")
mergedDs$Activity <- as.numeric(mergedDs$Activity)
mergedDs$Activity <- factor(mergedDs$Activity,labels = as.character(actLabels$V2))

# Remove the StudyType column by subsetting on megedDS as the means need to be 
# grouped by Subject and Activity. This narrows the table from 563 columns to 4 columns
tempDs <- melt(mergedDs[,1:563], id.vars=c("Activity", "Subject"))

# dcast to widen the table back from 4 columns to 563 columns calculating mean in the 
# process
meansBySubActivityDs <- dcast(tempDs, ... ~ variable, fun.aggregate = mean)

#reorder the columns of mergedDS so that Activity (col index 562) and 
# Subject (col index 563) are the first two columns
# remove the study type column
mergedDs <- select(mergedDs, c(562,563,1:561))

write.table(mergedDs, "./tidy_merged.txt", row.names = FALSE)
write.table(meansBySubActivityDs, "./tidy_meansBySubActivity.txt", row.names = FALSE)

# Change back to the working directory where we started
setwd(currentDir)