#Load required files into R from working directory
activity <- read.table("activity_labels.txt")
features <- read.table("features.txt")
subjecttrain <-read.table("subject_train.txt")
subjecttest<-read.table("subject_test.txt")
Xtest <- read.table("X_test.txt")
Xtrain <- read.table("X_train.txt")
Ytest <- read.table("y_test.txt")
Ytrain <- read.table("y_train.txt")
#Extract mean and standard deviation (std) fields from features, but not the angular groups
Meanstdfeatures <-grep("mean|std",features$V2)
#Using Meanstdfeature vector, extract only the appropriate fields regarding mean, std from test and train data sets
Xtrainext <- Xtrain[,Meanstdfeatures]
Xtestext <- Xtest[, Meanstdfeatures]
#gives the 79 extracted columns their correct feature names versus just numbers
featurenames <-features[Meanstdfeatures, ]
colnames(Xtestext) <-featurenames$V2
colnames(Xtrainext) <- featurenames$V2
#Gives activity and subject test and train activites correct column label
colnames(Ytest) <- c("activity")
colnames(Ytrain) <- c("activity")
colnames(subjecttest) <- c("subject")
colnames(subjecttrain) <- c("subject")
#Column bind together all parts of the test and traninging data set
completetrain <- cbind(subjecttrain, Ytrain, Xtrainext)
completetest <- cbind(subjecttest, Ytest, Xtestext)
#Load dplyr library
library(dplyr)
#Merge together full training and test sets for complete data set
complete <-bind_rows(completetrain, completetest)
#NOTE: I debated changing activity from number to readable characters such as WALKING for 1 etc.
#This is done with something like complete$activity[complete$activity == 1] <- "WALKING"
#This is a debatable area.  Some data scientists will alter repeated text to numbers to make processing easier.
#There are many "how do you change text to numbers" questions online.  I elected to leave activity as numbers
#
#To summarize for each member by the 6 activity levels, means for each extracted feature
#First change to more readable table using tbl_df command
completetbl <- tbl_df(complete)
#Then group by the subject, then activity so when summarising activities, will use groupings
completetblgrp <- group_by(completetbl, subject, activity)
#This single command processes mean for all the subgroupings, generates the 180 requested groups.
#Summarise_all does not summarise on grouped columns
completemeans <- summarise_all(completetblgrp, mean)