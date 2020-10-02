# before we start: we download and unzip the dataset

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# first step: we create one data set by merging the "training" and "test" sets. Before we need to read all the data elements and assign the column names. We also start labeling the data set with descriptive variable names.
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

merged_train <- cbind(y_train, subject_train, x_train)
merged_test <- cbind(y_test, subject_test, x_test)
merged_all <- rbind(merged_train, merged_test)


# second step: we extract only the measurements on the mean and standard deviation for each measurement.  

colNames <- colnames(merged_all)

mean_and_standarddev <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

subset4mean_and_standarddev <- merged_all[ , mean_and_standarddev == TRUE]


# third step: we use descriptive activity names to name the activities in the data set.

setActivityNames <- merge(subset4mean_and_standarddev, activityLabels,
                              by='activityId',
                              all.x=TRUE)


# last step: we create a second, independent tidy data set with the average of each variable for each activity and each subject. Then we write it into a .txt file.

secondSet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
secondSet <- secondSet[order(secondSet$subjectId, secondSet$activityId),]

write.table(secondSet, "secondSet.txt", row.name=FALSE)