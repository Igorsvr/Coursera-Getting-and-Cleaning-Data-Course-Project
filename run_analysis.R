# Download and unzip the data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Merging the training and the test sets to create one data set
# Test and Training files 
subjectTrain = read.table("./data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)
xTrain = read.table("./data/UCI HAR Dataset/train/x_train.txt",header=FALSE)
yTrain = read.table("./data/UCI HAR Dataset/train/y_train.txt",header=FALSE)

subjectTest = read.table("./data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)
xTest = read.table("./data/UCI HAR Dataset/test/x_test.txt",header=FALSE)
yTest = read.table("./data/UCI HAR Dataset/test/y_test.txt",header=FALSE)

# Path with all of the files 
path <- file.path("./Data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

# the names of the activities
featureNames <- read.table("./data/UCI HAR Dataset/features.txt")
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

# Organizing and combining raw data sets into single one
xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)

dim(xDataSet)
dim(yDataSet)
dim(subjectDataSet)

# Extract only the measurements on the mean and standard deviation for each measurement
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("./data/UCI HAR Dataset/features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("./data/UCI HAR Dataset/features.txt")[grep("-(mean|std)\\(\\)", read.table("./data/UCI HAR Dataset/features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)

# Use descriptive activity names to name the activities in the data set

yDataSet[, 1] <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"
View(yDataSet)
names(subjectDataSet) <- "Subject"
summary(subjectDataSet)

# Organizing and combining all data sets into single one
oneDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)
                    
# Defining descriptive names for all variables
names(oneDataSet) <- make.names(names(oneDataSet))
names(oneDataSet) <- gsub('Acc',"Acceleration",names(oneDataSet))
names(oneDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(oneDataSet))
names(oneDataSet) <- gsub('Gyro',"AngularSpeed",names(oneDataSet))
names(oneDataSet) <- gsub('Mag',"Magnitude",names(oneDataSet))
names(oneDataSet) <- gsub('^t',"TimeDomain.",names(oneDataSet))
names(oneDataSet) <- gsub('^f',"FrequencyDomain.",names(oneDataSet))
names(oneDataSet) <- gsub('\\.mean',".Mean",names(oneDataSet))
names(oneDataSet) <- gsub('\\.std',".StandardDeviation",names(oneDataSet))
names(oneDataSet) <- gsub('Freq\\.',"Frequency.",names(oneDataSet))
names(oneDataSet) <- gsub('Freq$',"Frequency",names(oneDataSet))

View(oneDataSet)
names(oneDataSet)

# independent tidy data set with the average of each variable for each activity and each subject
secData<-aggregate(. ~Subject + Activity, oneDataSet, mean)
secData<-secData[order(secData$Subject,secData$Activity),]

# write.table 
write.table(secData, file = "secData.txt",row.name=FALSE)
oneDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)
