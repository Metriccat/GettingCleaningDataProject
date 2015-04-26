# "Getting and Cleaning data" Coursera lecture by Jeff Leek, Roger D. Peng, and Brian Caffo
# Course project: tidying data from a wearable computing experiment
# Data source: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

library(plyr)

######## Step 1: Merge the training and the test sets to create one data set.
# read data from text files
# all data are numeric except the subject label and the activity label
nlines = -1 # for testing: nlines is nbr of lines to read, -1 = read all, use > 200

# training data
X_train = read.table("train/X_train.txt", nrows=nlines)
y_train = read.table("train/y_train.txt", nrows=nlines, colClasses = "factor")
subject_train = read.table("train/subject_train.txt", nrows=nlines, colClasses = "factor")

# test data
X_test = read.table("test/X_test.txt", nrows=nlines)
y_test = read.table("test/y_test.txt", nrows=nlines, colClasses = "factor")
subject_test = read.table("test/subject_test.txt", nrows=nlines, colClasses = "factor")

# build each train and test set by combining columns for
# subject, X data, and class label y
train = cbind(subject_train, X_train, y_train)
test = cbind(subject_test, X_test, y_test)

# final data set combines training data and test data
global = rbind(train, test)

# add variable (columns) names
# read from feature text file the names for the numeric data
features = read.table("features.txt",stringsAsFactors=FALSE)
colnames = features[,2]
# add the subject and activity names (non numeric data)
colnames = c("subject", colnames, "activity")
names(global) = colnames

######## Step 2: Extract only the measurements on the mean and standard deviation for each measurement. 
# filter the column names containing "mean" or "std"
global_m_std = global[, grep("subject|Mean|mean|std|activity", names(global))]

######## Step 3: Use descriptive activity names to name the activities in the data set
activity_labels = read.table("activity_labels.txt", colClasses = "factor")
# replace factor labels by activity descriptors
global_m_std$activity = mapvalues(global_m_std$activity, from = levels(global_m_std$activity), to = levels(activity_labels[,2]))

######## Step 4: Appropriately label the data set with descriptive variable names. 
# remove the "()" in names
names(global_m_std) = gsub("\\(\\)","",names(global_m_std))
# replace minus sign by point
names(global_m_std) = gsub("-","\\.",names(global_m_std))
# replace "t" and "f" by more descriptive names for time/frequency domain
names(global_m_std) = gsub("^t","time\\.",names(global_m_std))
names(global_m_std) = gsub("\\(t","\\(time\\.",names(global_m_std))
names(global_m_std) = gsub("^f","freq\\.",names(global_m_std))
# expand "Mag" to "Magnitude" and "Acc" to "Acceleration"
names(global_m_std) = gsub("Mag","Magnitude",names(global_m_std))
names(global_m_std) = gsub("Acc","Acceleration",names(global_m_std))
# correct a typo (spurious parenthesis in name)
names(global_m_std)[82] = "angle(time.BodyAccelerationJerkMean,gravityMean)"

######## Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
# get averages
tidy_means = aggregate(.~ activity + subject, data = global_m_std, FUN = "mean")
# set names to add "Means" at the start of the column names from the original data
names(tidy_means)[-c(1,2)] = sapply(names(tidy_means)[-c(1,2)], function(x) paste("Mean", x, sep="."))

######## Save tidy data as text file
write.table(tidy_means, "tidy_means.txt", row.name=FALSE)





