setwd("~/COURSE 3 Getting and Cleaning Data/Week4/Project")
getwd()

## Install required R packages that will be used in the analysis

install.packages("stringr")
library(stringr)

install.packages("data.table")
library(data.table)

install.packages("tidyr")
library(tidyr)

install.packages("dplyr")
library(dplyr)

install.packages("rmarkdown")
library(rmarkdown)

## Read the X_test.txt file 

X_test <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/test/X_test.txt")

##to see variable list in the features.txt file

features<- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/features.txt")
head(features)

##use str_which to know the indexes of all variable names which have "mean" or "std"

var_index <- str_which(features$V2, c("mean","std"))
var_index

##there are 44 variables which have mean or std in them

##Use str_subset and str_replace_all to get variable names and clean the labels

var_names<-str_subset(features$V2, c("mean", "std"))
var_names_modified <- str_replace_all(var_names, "-"=".")
var_names_modified


##Using fread() function, subset the X_test dataset to include only selected columns
## the second argument is the var_index to select the columns

features_subset1 <- fread("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/test/X_test.txt", select=var_index)

##if you run the dim function, it will show 2947 rows and 44 columns

## Add actitivty_ID and subject_ID columns to the above dataset

subject_ID_test <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/test/subject_test.txt")

Activity_ID_test <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/test/y_test.txt")

##Append variables Subject_ID and Activity_ID to features_subset1 of test dataset

test_dataset1 <-cbind(subject_ID_test, Activity_ID_test, features_subset1)

## Repeat above steps for X_train dataset

X_train <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/train/X_train.txt")

features_subset2 <- fread("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/train/X_train.txt", select=var_index)

subject_ID_train <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/train/subject_train.txt")

Activity_ID_train <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/train/y_train.txt")

test_dataset2 <-cbind(subject_ID_train, Activity_ID_train, features_subset2)

##Use rbind to combine test_datset1 and test_dataset2

combined_dataset <- rbind(test_dataset1, test_dataset2)

## Assign column names to the combined dataset using names()

names(combined_dataset) <-c("subject_ID", "activity_ID", var_names_modified)

##Read the data file that containts description of activities - activity_ID

activity_desc <- read.table("C:/Coursera/COURSE 3 Getting and Cleaning Data/Week4/Project/UCI HAR Dataset/activity_labels.txt")

##Merge the combined dataset with the activity_desc

dataset_with_activity <- merge(combined_dataset, activity_desc, by.x="activity_ID", by.y="V1", all=TRUE)

##Add column name to the newly joined column for activity description
colnames(dataset_with_activity)[47]<-"activity_description"

## reorder columns in the tidy dataset

dataset_reordered <- dataset_with_activity[c(2, 1, 47, 3:46)]

##Sort the dataset by subject_ID and activity_ID

sorted_dataset <- arrange(dataset_reordered, subject_ID, activity_ID)

##Creates a second, independent tidy data set with the average of each variable 
##for each activity and each subject.

final <- sorted_dataset %>% group_by(subject_ID, activity_ID, activity_description) %>% summarise_each(funs(mean))
head(final)
dim(final)

