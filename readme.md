# Getting and Cleaning Data Final Project

## Summary
This repo contains an R script, "run_analysis.R" that downloads a zip archive of data pertaining to Samsung Wearable devices,
combines various data elements together and then writes a new tidy dataset out in text called Wearables_Aggregated.

## Purpose
This script achieves 5 specific goals:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average 
of each variable for each activity and each subject.
	
## Method
The script performs the following actions:
* Creates a directory called wearables and downloads the wearables zip archive
* Downloads the general information about activity labels and features
* Downloads the tables that contain observations, activity key and subject keys for both 
	test and training data
* Merges test and training data
* Names all the variables in the observations based on the features dataset
* Selects only variables that inlclue mean() or sd().  The others that may include mean in a 
	different format were not included as they were derivative and used to create the angle variables
* Combines activity data with observations and subject labels
* Calculates the mean of each variable for each subject for each activity 
 
 ## Codebook
 A codebook can be found in the repo that gives further information about the variables included
 in the tidy dataset.
