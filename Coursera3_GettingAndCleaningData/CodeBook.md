---
title: "CodeBook"
author: "EA McKenzie"
date: "01/07/2015"
output: html_document
---

# GettingAndCleaningData
For Coursera: Data Science Specialization - course project

This codebook briefly describes the dataset and work done on it in producing the UCIHAR_tidy.txt dataset. This is intended as an update to the provided, complete documentation of the dataset (**UCI HAR Dataset.zip**).

## The UCI HAR Dataset: Source and Purpose
See **UCI HAR Dataset.zip/README.txt** for full documentation.

The dataset may be obtained from the UCI Machine Learning Repository. Its title is **"Human Activity Recognition Using Smartphones Dataset (version 1.0)"**, by authors **Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto** at the Non Linear Complex Systems Laboratory at Università degli Studi di Genova (Genoa, Italy; www.smartlab.ws).

The purpose is to provide a predictive dataset for identifying human activities based on the accelerometer and gyroscope in a smartphone. Once human movements can be identified, this information might be used in developing a wide variety of applications on smartphones or other uses for data downloaded from smartphones.

## Collection and Pre-processing of the Dataset
See **UCI HAR Dataset.zip/README.txt** and **features_info.txt** for full documentation.

Data was collected from 30 volunteer subjects performing any of six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING), labeled manually from video, while wearing a Samsung Galaxy S II attached at the waist. Data (3-axial linear acceleration and 3-axial angular velocity) were collected at a constant rate of 50Hz.

Raw data was cleaned with noise filters and sampled in 2.56 sec windows with 50% overlap. Acceleration was separated into gravitational and body motion components using a Butterworth low-pass filter. Variables were calculated from this processed dataset.

Jerk (changes in acceleration) was calculated from the time derivative of body linear acceleration and angular velocity, producing tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ.

Magnitude of movement across the 3 dimensions was calculated using the Euclidean norm, producing tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, and tBodyGyroJerkMag.

Frequency was calculated using a Fast Fourier Transform, producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, and fBodyGyroJerkMag.

Subjects were randomly assigned to the Training (70% of data) or Test (30%) datasets, to allow predictive analysis.

## Description of Variables
See **UCI HAR Dataset.zip/features_info.txt** for full documentation, and **UCI HAR Dataset/features.txt** for the complete list of variables.

**The complete set of signals,** where X, Y, and Z are separate signals in the 3 dimensions, Mag is magnitude of movement across the 3 dimensions, Jerk is change in acceleration, and f indicates calculated frequencies:

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

**The variables calculated from each signal,** with normalization (see **README.txt** and **features_info.txt**):

mean(): Mean value

std(): Standard deviation

mad(): Median absolute deviation 

max(): Largest value in array

min(): Smallest value in array

sma(): Signal magnitude area

energy(): Energy measure. Sum of the squares divided by the number of 
values

iqr(): Interquartile range 

entropy(): Signal entropy

arCoeff(): Autorregresion coefficients with Burg order equal to 4

correlation(): correlation coefficient between two signals

maxInds(): index of the frequency component with largest magnitude

meanFreq(): Weighted average of the frequency components to obtain a 
mean frequency

skewness(): skewness of the frequency domain signal 

kurtosis(): kurtosis of the frequency domain signal 

bandsEnergy(): Energy of a frequency interval within the 64 bins of the 
FFT of each window

angle(): Angle between two vectors, using the means of 5 signals: gravity, tBodyAcc, tBodyAccJerk, tBodyGyro, and tBodyGyroJerk

## Producing the Tidy Dataset
See **README.md** for details of the R script (**run_analysis.R**) used to produce the tidy dataset (**UCIHAR_tidy.txt**).

The dataset was assembled by joining subject, activity, and variable labels to the processed dataset (**X_train.txt** and **X_test.txt**). Training and test data were combined to provide the complete dataset.

Variables were subsetted to only those containing the mean and standard deviations of the signals.

The mean of each of these variables (signal means and standard deviations) was taken for each subject x activity combination. For example, subject 1 WALKING appears as an observation row, containing the means of data from subject 1 walking for variables tBodyAcc.mean...X, tBodyAcc.std...X, etc.

This dataset of means for subject x activity mean & st.dev. is output as the space-separated text file **UCIHAR_tidy.txt**.

**Final list of variables:**

*Note, units are unclear due to pre-processing (normalization and filters - see **README.txt**), but means are in their relevant units and standard deviations are in standard deviation units.*

"tBodyAcc.mean...X" 

"tBodyAcc.mean...Y" 

"tBodyAcc.mean...Z" 

"tBodyAcc.std...X" 

"tBodyAcc.std...Y" 

"tBodyAcc.std...Z" 

"tGravityAcc.mean...X" 

"tGravityAcc.mean...Y" 

"tGravityAcc.mean...Z" 

"tGravityAcc.std...X" 

"tGravityAcc.std...Y" 

"tGravityAcc.std...Z" 

"tBodyAccJerk.mean...X" 

"tBodyAccJerk.mean...Y" 

"tBodyAccJerk.mean...Z" 

"tBodyAccJerk.std...X" 

"tBodyAccJerk.std...Y" 

"tBodyAccJerk.std...Z" 

"tBodyGyro.mean...X" 

"tBodyGyro.mean...Y" 

"tBodyGyro.mean...Z" 

"tBodyGyro.std...X" 

"tBodyGyro.std...Y" 

"tBodyGyro.std...Z" 

"tBodyGyroJerk.mean...X" 

"tBodyGyroJerk.mean...Y" 

"tBodyGyroJerk.mean...Z" 

"tBodyGyroJerk.std...X" 

"tBodyGyroJerk.std...Y" 

"tBodyGyroJerk.std...Z" 

"tBodyAccMag.mean.." 

"tBodyAccMag.std.." 

"tGravityAccMag.mean.." 

"tGravityAccMag.std.." 

"tBodyAccJerkMag.mean.." 

"tBodyAccJerkMag.std.." 

"tBodyGyroMag.mean.." 

"tBodyGyroMag.std.." 

"tBodyGyroJerkMag.mean.." 

"tBodyGyroJerkMag.std.." 

"fBodyAcc.mean...X" 

"fBodyAcc.mean...Y" 

"fBodyAcc.mean...Z" 

"fBodyAcc.std...X" 

"fBodyAcc.std...Y" 

"fBodyAcc.std...Z" 

"fBodyAcc.meanFreq...X" 

"fBodyAcc.meanFreq...Y" 

"fBodyAcc.meanFreq...Z" 

"fBodyAccJerk.mean...X" 

"fBodyAccJerk.mean...Y" 

"fBodyAccJerk.mean...Z" 

"fBodyAccJerk.std...X" 

"fBodyAccJerk.std...Y" 

"fBodyAccJerk.std...Z" 

"fBodyAccJerk.meanFreq...X" 

"fBodyAccJerk.meanFreq...Y" 

"fBodyAccJerk.meanFreq...Z" 

"fBodyGyro.mean...X" 

"fBodyGyro.mean...Y" 

"fBodyGyro.mean...Z" 

"fBodyGyro.std...X" 

"fBodyGyro.std...Y" 

"fBodyGyro.std...Z" 

"fBodyGyro.meanFreq...X" 

"fBodyGyro.meanFreq...Y" 

"fBodyGyro.meanFreq...Z" 

"fBodyAccMag.mean.." 

"fBodyAccMag.std.." 

"fBodyAccMag.meanFreq.." 

"fBodyBodyAccJerkMag.mean.." 

"fBodyBodyAccJerkMag.std.." 

"fBodyBodyAccJerkMag.meanFreq.." 

"fBodyBodyGyroMag.mean.." 

"fBodyBodyGyroMag.std.." 

"fBodyBodyGyroMag.meanFreq.." 

"fBodyBodyGyroJerkMag.mean.." 

"fBodyBodyGyroJerkMag.std.." 

"fBodyBodyGyroJerkMag.meanFreq.."
