# To downlaoad an drecursively display the files
if(!file.exists("./data2")){dir.create("./data2")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data2/Dataset.zip",method="curl")
unzip(zipfile="getdata-projectfiles-UCI HAR Dataset.zip")
path_read <- file.path("UCI HAR Dataset")
files<- list.files(path_read, recursive = T)
files

# To read the assignment files such as activity lables, subject and features

activitytest_data <- read.table( file.path(path_read, "test", "y_test.txt"))
activitytrain_data <- read.table( file.path(path_read, "train", "y_train.txt"))

subjecttest_data <- read.table( file.path(path_read, "test", "subject_test.txt"))
subjecttrain_data <- read.table( file.path(path_read, "train", "subject_train.txt"))

featurestest_data <- read.table( file.path(path_read, "test", "X_test.txt"))
featurestrain_data <- read.table( file.path(path_read, "train", "X_train.txt"))

# To merge the test and train data and set the variable name

Subject_data_All <- rbind(subjecttest_data, subjecttrain_data)
Activity_data_All <- rbind(activitytest_data, activitytrain_data)
Features_data_All <- rbind(featurestest_data, featurestrain_data)

names(Subject_data_All) <- c("subject")
names(Activity_data_All) <- c("activity")
Features_names <- read.table(file.path (path_read, "features.txt", head= FALSE))
names(Features_data_All) <- Features_names$V2

mergedata <- cbind(Subject_data_All, Activity_data_All)
mydata <- cbind(Features_data_All, mergedata)

features_subset<- Features_names$V2[grep("mean\\(\\)| std\\(\\)", Features_names$V2)]
names<- c(as.character(features_subset), "subject", "activity")
mydata<- subset(mydata, select= names)

# to read activity lables

lable_activity<- read.table(file.path(path_read, "activity_lables.txt"))
names(mydata) <-gsub("^t", "time", names(mydata))
names(mydata) <-gsub("^f", "frequency", names(mydata))
names(mydata) <-gsub("^Acc", "Accelerometer", names(mydata))
names(mydata) <-gsub("^Gyro", "Gyroscope", names(mydata))
names(mydata) <-gsub("^Mag", "Magnitude", names(mydata))
names(mydata) <-gsub("^BodyBody", "Body", names(mydata))

# To Create a tiday data

library(plyr)
tidydata <- aggregate(. ~subject+activity, mydata, mean)
tidydata <- tidydata[order(tidydata$subject, tidydata$activity),]
write.table(tidydata, file= "mytidydata.txt", row.name=FALSE)

