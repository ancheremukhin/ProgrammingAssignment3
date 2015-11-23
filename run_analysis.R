# read data sets
dt_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
dt_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")

labels_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
labels_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
# merge data sets
dt <- rbind(dt_train, dt_test)
labels <- rbind(labels_train, labels_test)
subject <- rbind(subject_test, subject_train)
# read features and extract only mean and std
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = "")
indexes <- subset(features, grepl("mean()", V2, fixed = TRUE) | grepl("std()", V2, fixed = TRUE))
mean_std_dt <- dt[,indexes[,1]]
#  labels the data set with descriptive variable names
colnames(mean_std_dt) <- features[,2][indexes[,1]]
# read activity seat and name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
mean_std_dt[,"activity"] <- sapply(labels$V1, function(i) { activities$V2[i] })
# add subject
mean_std_dt[,"subject"] <- subject
# produce new tidy data set

aggregate(. ~ activity + subject, data = mean_std_dt, mean)