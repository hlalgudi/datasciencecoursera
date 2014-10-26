# This script runs on UCI HAR dataset which should be downloaded to
# the current or same directory as the script.
# The output of the script is in file tidy.txt which stores the 
# mean value by Activity and Subject for data with std & mean from original data
#
# 1: Merges the training and the test sets to create one data set.
# Read the training set & bind the related activity & subject data
training <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(activity)<-c("Activity")
colnames(subject)<-c("Subject")
activity <- as.factor(activity)
subject <- as.factor(subject)
training <- cbind(training, activity, subject)

# Read the test set & bind the related activity and subject data
test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
activity <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
colnames(activity)<-c("Activity")
colnames(subject)<-c("Subject")
activity <- as.factor(activity)
subject <- as.factor(subject)
test <- cbind(test, activity, subject)

# Merge training and test set
testTrain <- rbind(training, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Read the feature names
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, colClasses="character")
nr <- nrow(features)
# select only mean and std variables
sel <- grep(".*mean*|.*std*", f[,2], ignore.case=TRUE)
features <- features[sel,]
# add feature & activity to the list
features <- rbind(features,c(nr+1,"Activity"))
features <- rbind(features,c(nr+2,"Subject"))
features$V1 <- as.factor(features$V1)
sel <- c(sel, nr+1, nr+2)
  
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
testTrain <- testTrain[,sel]
colnames(testTrain) <- features$V2

#5. From the data set in step 4, creates a second, independent 
#   tidy data set with the average of each variable for each activity and each subject.
tidy <- aggregate(testTrain, by=list(Activity=testTrain$Activity, Subject=testTrain$Subject), mean)
tidy <- tidy[,-(89:90)]
write.table(tidy, "tidy.txt", sep="\t", row.names=FALSE)
