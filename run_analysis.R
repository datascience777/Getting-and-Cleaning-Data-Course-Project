# before we start: we download and unzip the dataset:
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# first step: we create one data set by merging the "training" and "test" sets. Before we need to enter the supporting metadata (features and labels) of this data into 2 variables, read all the data elements and assign the column names. 

feature_names <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)

subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
features <- rbind(features_train, features_test)

colnames(features) <- t(feature_names[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

merged_data <- cbind(features,activity,subject)


# second step: we extract only the measurements on the mean and standard deviation for each measurement.  

columns_meanSTD <- grep(".*Mean.*|.*Std.*", names(merged_data), ignore.case=TRUE)
required_columns <- c(columns_meanSTD, 562, 563)

subset <- merged_data[,required_columns]


# third step: we use descriptive activity names to name the activities in the data set.

subset$Activity <- as.character(subset$Activity)
for (i in 1:6){
  subset$Activity[subset$Activity == i] <- as.character(activity_labels[i,2])
}

subset$Activity <- as.factor(subset$Activity)

# fourth step: we label the data set with more appropiate variable names:

names(subset)<-gsub("Acc", "Accelerometer", names(subset))
names(subset)<-gsub("Gyro", "Gyroscope", names(subset))
names(subset)<-gsub("BodyBody", "Body", names(subset))
names(subset)<-gsub("Mag", "Magnitude", names(subset))
names(subset)<-gsub("^t", "Time", names(subset))
names(subset)<-gsub("^f", "Frequency", names(subset))
names(subset)<-gsub("tBody", "TimeBody", names(subset))
names(subset)<-gsub("-mean()", "Mean", names(subset), ignore.case = TRUE)
names(subset)<-gsub("-std()", "STD", names(subset), ignore.case = TRUE)
names(subset)<-gsub("-freq()", "Frequency", names(subset), ignore.case = TRUE)
names(subset)<-gsub("angle", "Angle", names(subset))
names(subset)<-gsub("gravity", "Gravity", names(subset))

# last step: we create a second, independent tidy data set with the average of each variable for each activity and each subject. Then we write it into a .txt file.

subset$Subject <- as.factor(subset$Subject)
subset <- data.table(subset)

tidyData <- aggregate(. ~Subject + Activity, subset, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)