Peer-graded Assignment: Getting and Cleaning Data Course Project

The original data was processed by:

    * Merging the training and the test sets to create one data set.
    * Extracting only the measurements on the mean and standard deviation for each measurement.
    * Using descriptive activity names to name the activities in the data set
    * Appropriately labeling the data set with descriptive activity names.
    * Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

The attached file "run_analysis.R" perform the mentioned steps.

The main variables used are:

    subject_train, activity_train, features_train, subject_test, activity_test and features_test, allocating the data from the downloaded files.
    subject, activity, features and merged_data, merging the previous datasets.
    subset, extracting the desired information from the merging
