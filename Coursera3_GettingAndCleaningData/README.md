# GettingAndCleaningData
For Coursera: Data Science Specialization - course project

This README describes how the files in this directory fit together and what the analysis file does.

## Files in this directory:
  README.md           = This file, describing the analysis and the files in this directory.
  
  run_analysis.R      = The R script used for performing the analysis. Takes UCI HAR Dataset.zip,
                        unzipped, in the working directory, as input. Gives UCIHAR_tidy.txt as output.

  CodeBook.md         = A code book describing variables, dataset, and clean up work performed.
  
  UCIHAR_tidy.txt     = The tidy dataset submitted on Coursera, output from the R script. Contains the 
                        means of each variable's mean and standard deviation across the observations of 
                        each individual performing each activity. In other words, each row is an 
                        individual performing one activity, and each column is the mean of a single 
                        variable's mean or standard deviation. Space-separated text file with header,
                        no row names, 40 observations and 80 variables (1 factor followed by 79 numeric).
  
  UCI HAR Dataset.zip = The original data, input to the R script. Contains its own README file.

## Details of run_analysis.R:
  Input: Unzipped (decompressed) folder of UCI HAR Dataset
  
  Output: UCIHAR_tidy.txt, a tidy dataset containing means of variables by individual and activity
  
  Packages required: stringr
  
  The first section of the script lets you set your working directory if necessary, load libraries, and 
  load the data files from UCI HAR Dataset.
  
  Next, variable names (columns) and activity names (factor levels for a categorical variable) are 
  created from the original files. Duplicate variable names are distinguished by adding ".0" to the end 
  of the name.
  
  Data (X_train.txt and X_test.txt and their labels) are assembled to form the separate Test and Training 
  datasets. These are further combined to form the complete HAR dataset. Optional code permits saving the 
  complete dataset as UCI HAR Dataset.csv.
  
  Next, variables containing means and standard deviations are identified by searching for the character 
  strings "mean" or "std". Mean frequency variables were included here. These 79 variables are subsetted 
  to form the HAR.ms dataset. Optional code permits saving the means and standard deviations dataset as 
  UCI HAR Means and StDevs.csv.
  
  Finally, the tidy dataset is created. Subject and activity are clipped together to create a numerical 
  index of the subject-activity categories. A for-loop is used to find and store the means of each 
  variable within each subject-activity category. The resulting dataset is renamed and assigned the 
  correct types for each variable, then output as UCIHAR_tidy.txt. Optional code also permits saving the 
  tidy dataset as UCI HAR Subject Activity Means.csv.
