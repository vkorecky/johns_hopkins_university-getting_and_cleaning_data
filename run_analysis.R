# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following. 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
# setwd("D:/School/Johns Hopkins University - Data Science Specialization/03 - Getting and Cleaning Data/Course Project/Course Project")

run <- function(){  
  # Merges the training and the test sets to create one data set.
  trainData <- read.table("./data/train/X_train.txt")
  dim(trainData)
  head(trainData)
  trainLabel <- read.table("./data/train/y_train.txt")
  table(trainLabel)
  trainSubject <- read.table("./data/train/subject_train.txt")
  testData <- read.table("./data/test/X_test.txt")
  dim(testData)
  testLabel <- read.table("./data/test/y_test.txt") 
  table(testLabel) 
  testSubject <- read.table("./data/test/subject_test.txt")
  joinData <- rbind(trainData, testData)
  dim(joinData)
  joinLabel <- rbind(trainLabel, testLabel)
  dim(joinLabel)
  joinSubject <- rbind(trainSubject, testSubject)
  dim(joinSubject)
  
  # Extracts only the measurements on the mean and standard deviation for each measurement. 
  features <- read.table("./data/features.txt")
  dim(features) # 561*2
  meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
  length(meanStdIndices) # 66
  joinData <- joinData[, meanStdIndices]
  dim(joinData) # 10299*66
  names(joinData) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # remove "()"
  names(joinData) <- gsub("mean", "Mean", names(joinData)) # capitalize M
  names(joinData) <- gsub("std", "Std", names(joinData)) # capitalize S
  names(joinData) <- gsub("-", "", names(joinData)) # remove "-" in column names 


  # Uses descriptive activity names to name the activities in the data set
  activity <- read.table("./data/activity_labels.txt")
  activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
  substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
  substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
  activityLabel <- activity[joinLabel[, 1], 2]
  joinLabel[, 1] <- activityLabel
  names(joinLabel) <- "activity"  

  # Appropriately labels the data set with descriptive variable names. 
  names(joinSubject) <- "subject"
  cleanedData <- cbind(joinSubject, joinLabel, joinData)
  dim(cleanedData) # 10299*68
  write.table(cleanedData, "merged_data.txt") # write out the 1st dataset

  # Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
  subjectLen <- length(table(joinSubject)) # 30
  activityLen <- dim(activity)[1] # 6
  columnLen <- dim(cleanedData)[2]
  result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen)
  result <- as.data.frame(result)
  colnames(result) <- colnames(cleanedData)
  row <- 1
  for(i in 1:subjectLen) {
    for(j in 1:activityLen) {
      result[row, 1] <- sort(unique(joinSubject)[, 1])[i]
      result[row, 2] <- activity[j, 2]
      bool1 <- i == cleanedData$subject
      bool2 <- activity[j, 2] == cleanedData$activity
      result[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
      row <- row + 1
    }
  }
  head(result)
  write.table(result, "data_with_means.txt") # write out the 2nd dataset
}
