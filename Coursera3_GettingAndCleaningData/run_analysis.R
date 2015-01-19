# Set your working directory to the folder where you saved the UCI HAR Dataset:
#setwd("~/Desktop/Coursera/DA03_GetCleanData")

# Load libraries (please install them first if needed):
library(stringr)

# Load the several dataset files, assuming the folder UCI HAR Dataset is in your working directory
# and contains all the files in their original folders:
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep="")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
test.subj <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
test.X <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
test.Y <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")
train.subj <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
train.X <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
train.Y <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")

# Notice that features.txt includes some duplicate names:
#duplicated(features$V2) 
# Duplicates are all in "bands energy", see below description from features_list.txt:
# "bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window."
# So, make unique column names vector from features by adding "0" at ends of duplicated names:
feature.names <- as.character(features$V2)
dup1 <- duplicated(feature.names)
feature.names[dup1] <- paste(feature.names[dup1], 0*dup1[dup1])
dup2 <- duplicated(feature.names)
feature.names[dup2] <- paste(feature.names[dup2], 0*dup2[dup2])
feature.names <- make.names(feature.names)

# Set column names and combine each dataset:
colnames(test.X) <- feature.names
colnames(test.subj) <- "subject"
colnames(test.Y) <- "key"
colnames(train.X) <- feature.names
colnames(train.subj) <- "subject"
colnames(train.Y) <- "key"
colnames(activity.labels) <- c("key","activity")

# Use activity as a key for test.Y and train.Y to obtain descriptive activity names:
test.activity <- merge(activity.labels, test.Y)
train.activity <- merge(activity.labels, train.Y)

# Column bind to form the Test and Train dataset:
Test <- cbind(test.subj, test.activity$activity, test.X)
Train <- cbind(train.subj, train.activity$activity, train.X)

# Rename the activity column in both datasets to match:
colnames(Test)[2] <- "activity"
colnames(Train)[2] <- "activity"

# Row bind Test and Train to form the HAR complete dataset:
HAR <- rbind(Train, Test)
HAR <- HAR[ order(HAR$subject, HAR$activity),]
# Make subject a factor variable. It needed to be numeric for the order() operation above.
HAR$subject <- as.factor(HAR$subject)

# Optionally, delete the # and run the line below to save a CSV file of the complete dataset:
#write.csv(HAR, file="UCI HAR Dataset.csv")

# Identify the columns containing mean and standard deviation:
means <- str_detect(string=colnames(HAR), pattern="mean")
stdevs <- str_detect(string=colnames(HAR), pattern="std")
#str_detect from the "stringr" library returns a T/F vector along the input for locations of 
#the requested character pattern

# Subset HAR for columns 1, 2, and columns containing means (including mean frequencies) and 
# standard deviations:
subsetter <- as.logical(means + stdevs)
subsetter[c(1,2)] <- TRUE
HAR.ms <- HAR[,subsetter]

# Optionally, save the complete means & standard deviations dataset:
#write.csv(HAR.ms, file="UCI HAR Means and StDevs.csv")

# Save a "tidy" dataset of the means of means & standard deviations (HAR.ms columns), 
# split by subject and by activity:
# Paste for a new "index" column of combined subject and activity:
HAR.ms$index <- paste(HAR.ms$subject, HAR.ms$activity)

# Add a numeric index "key" column matching "index", to loop over:
index.labels <- data.frame(unique(HAR.ms$index),seq_along(unique(HAR.ms$index)))
colnames(index.labels) <- c("index","key")
HAR.ms <- merge(HAR.ms, index.labels)

# Use a double for-loop to loop through: (i) the numeric index of subject and activity, 
# and (j) the variable columns
HAR.tidy <- matrix(nrow=40, ncol=80)
for(i in 1:40)
{
  row.temp <- vector()
  row.temp[1] <- as.character(index.labels$index[i])
  for(j in 4:82)
  {
    row.temp[j-2] <- mean(HAR.ms[HAR.ms$key==i,j])
  }
  HAR.tidy[i,1:80] <- row.temp
}

# Set the types and column names:
HAR.tidy <- data.frame(HAR.tidy, stringsAsFactors=FALSE)
colnames(HAR.tidy)[2:80] <- colnames(HAR.ms)[4:82]
colnames(HAR.tidy)[1] <- "subject.activity"
HAR.tidy$subject.activity <- as.factor(HAR.tidy$subject.activity)
for(k in 2:80)
{
  HAR.tidy[,k] <- as.numeric(HAR.tidy[,k])
}

# Optionally, save the tidy dataset as a CSV or TXT:
#write.csv(HAR.tidy, file="UCI HAR Subject Activity Means.csv")
write.table(HAR.tidy, file="UCIHAR_tidy.txt", row.names=FALSE)

