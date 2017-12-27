################# Section for reading in Data ################################################################

#Create a directory named wearables to save files, change to working directory
dir.create("./Wearables")
setwd("./Wearables")

#Download zip file
fileaddress <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileaddress, "wearables_zip.zip")

#See list of files, create list of filenames
unzipped <- unzip("wearables_zip.zip", list=TRUE)
file_ls <- as.character(unzipped$Name)

#read in required tables
# gives the labels of the 6 activity types
activity_labels <- read.table(unz("wearables_zip.zip", file_ls[1]))

# features gives the names of the 561 features that were measured
features <- read.table(unz("wearables_zip.zip", file_ls[2]))

# gives the subject id for each of the 2947 observations
test_subject <- read.table(unz("wearables_zip.zip", file_ls[16]))

# gives 2947 observations of 561 features
test_data <- read.table(unz("wearables_zip.zip", file_ls[17]))

# gives the activity name ocurring for each of the 2947 observations
test_labels <- read.table(unz("wearables_zip.zip", file_ls[18]))

# gives the subject id for each of the 7352 training observations
train_subject <- read.table(unz("wearables_zip.zip", file_ls[30]))

# gives 7352 training observations of 561 features
train_data <- read.table(unz("wearables_zip.zip", file_ls[31]))

# gives the activity name ocurring for each of the 7352 training observations
train_labels <- read.table(unz("wearables_zip.zip", file_ls[32]))


############################### Section for Combining Data ##################################################
#use DPLYR package for data manipulation
require("dplyr")

# combine test and train data
all_data <- rbind(test_data,train_data)
all_labels <- rbind(test_labels, train_labels)
all_subject <- rbind(test_subject, train_subject)

# Label the 541 Variables using the features list
names(all_data) <- features[,2]

# rename columns prior to combining
all_subject <- rename(all_subject, SubjectID=V1)
all_labels <- rename(all_labels, ActivityID=V1)

# note test and train data has now been combined for observations, labels and subjects.
# The label and subject columns have yet to be combined with the observation data.

###################################### Select only mean and SD vars#####################################

# Create a list of all var names that include mean or std, only including those followed by parentheses since
# the others are additional vectors obtained by averaging the signals in a signal window sample. 
# These additional vectors are used on the angle() variable:

meanstd <- grep("mean\\()|std\\()",features$V2, ignore.case = TRUE) 
all_data_filt <- all_data[,meanstd]

######################################## Name activiites and combine subject, activity labels and obs #####

# Combine data with subject id and activity label  
all_comb_filt <- cbind(all_subject,all_labels,all_data_filt)
# Add activity labels using merge
all_act <- merge(all_comb_filt,activity_labels,by.x="ActivityID", by.y= "V1")
# Rename V1 to Activityname
all_act <- rename(all_act, Activityname = V2)
# Reorder data then drop ActivityID
all_act <- select(all_act, SubjectID, Activityname, everything())
all_act <- select(all_act, -ActivityID)

# Note the data now has descriptive variable names and each activity is an actual description rather than a 
#code

###################################  Calculate the average of each variable by subject by activity##########
aggdata <- aggregate(all_act[,3:68], list(SubjectID=all_act$SubjectID, Activityname= all_act$Activityname), mean)


#write out final table
write.table(aggdata,file="Wearables_Aggregated.txt",row.names=FALSE)
