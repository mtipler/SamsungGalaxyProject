#Read the tables
X_test = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/test/X_test.txt")
X_train = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/train/X_train.txt")

#Merge the tables
FullDataSet <- rbind(X_test, X_train)

#Read the name of for each column from the features.txt file
features <- scan("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/features.txt", what=character())

##The scan function created a vector. Every odd variable was a number, every even number was the variable was the correct column name.
##Grabbing the even variables (the correct column names) only
features2 <- features[c(FALSE, TRUE)]

##Create a logical vector - true if the column name contains "mean()" or "std()", false otherwise
MeanSTDVariables <- grepl("mean()",features2) | grepl("std()",features2)


##Subset based on the logical vector - so you only have the columns which have names containing "mean()" or "std()"
MeanSTDDAtaSet1 <- FullDataSet[,MeanSTDVariables]


##Subset features2 - grabbing only the names of the mean or std variables
features3 <- features2[MeanSTDVariables]


##Renames the varibales in MeanSTDDAtaSet1 so the variable names describe the feature
names(MeanSTDDAtaSet1) <- features3


##REad the file containing activity codes for test
y_test = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/test/y_test.txt")

##Read the file containing the activity codes for train
y_train = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/train/y_train.txt")

##Read the file containing the subject codes for test
subject_test = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/test/subject_test.txt")

##Read the file containing the subject codes for train
subject_train = read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset (1)/UCI HAR Dataset/train/subject_train.txt")



#Merge the activity code tables
y_all <- rbind(y_test, y_train)

#Merge the subject code tables
subject_all <- rbind(subject_test, subject_train)


##Rename the variable in y_all
library(plyr)
y_all <- rename(y_all, c("V1"="Activity"))

##Rename the variable in subject_all
subject_all <- rename(subject_all, c("V1"="subject"))

##Join the activity codes to the MeanSTD Dataset
MeanSTDDAtaSet2 <- cbind(y_all, MeanSTDDAtaSet1)



##Join the subject codes to the MeanSTD Dataset
MeanSTDDAtaSet3 <- cbind(subject_all, MeanSTDDAtaSet2)


#Rename the activity variables#
MeanSTDDAtaSet4 <- MeanSTDDAtaSet3
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "1"] <- "Walking"
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "2"] <- "Walking_Upstairs"
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "3"] <- "Walking_Downstairs"
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "4"] <- "Sitting"
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "5"] <- "Standing"
MeanSTDDAtaSet4$Activity[MeanSTDDAtaSet4$Activity == "6"] <- "Laying"



##Create a new Dataset with the mean of each variable for each subject and activity combination
SamsungGalaxyData <- aggregate(as.matrix(MeanSTDDAtaSet4[,3:81]), as.list(MeanSTDDAtaSet4[,1:2]), FUN = mean)



