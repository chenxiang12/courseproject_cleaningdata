## Load package
library(dplyr)

## Load data
dir <- "./UCI HAR Dataset"
train_dir <- "./UCI HAR Dataset/train"
test_dir <- "./UCI HAR Dataset/test"
subject_train <- read.table(paste(train_dir, "subject_train.txt", sep = "/"))
subject_test <- read.table(paste(test_dir, "subject_test.txt", sep = "/"))
y_train <- read.table(paste(train_dir, "y_train.txt", sep = "/"))
y_test <- read.table(paste(test_dir, "y_test.txt", sep = "/"))
X_train <- read.table(paste(train_dir, "X_train.txt", sep = "/"))
X_test <- read.table(paste(test_dir, "X_test.txt", sep = "/"))

features <- read.table(paste(dir, "features.txt", sep = "/"), stringsAsFactors = FALSE)

## Merge data and rename coloum variables and activity names
subject_all <- rbind(subject_train, subject_test)
##subject_all <- rename(subject_all, subject_ID = V1)
names(subject_all) <- c("subject_ID")

y_all <- rbind(y_train, y_test)
##y_all <- rename(y_all, activity = V1)
names(y_all) <- c("activity")
y_all$activity <- factor(y_all$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

X_all <- rbind(X_train, X_test)
names(X_all) <- features[[2]]

## Extracts only the measurements on the mean and standard deviation
X_all <- X_all[, grep("mean|std", names(X_all))]

## Combine all related data about a measurement
data_all <- cbind(subject_all, y_all, X_all)

## Order the measurement according to subject_ID and activity
data_all <- arrange(data_all, subject_ID, activity)

## Get the tidy data we need
data_all <- group_by(data_all, subject_ID, activity)
tidy_data <- summarise_each(data_all, funs(mean))

## Save the tidy data into a txt file
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE, quote = FALSE)
