# A reminder to set an appropriate working directory
# setwd("~/Development/coursera/data_cleaning/courseproject")

library(reshape2)
library(plyr)

# Download Samsung data set if not already present
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/UCI HAR Dataset.zip", method = "curl")
dateDownloaded <- date()
dateDownloaded

# Decompress file
unzip("./data/UCI HAR Dataset.zip", exdir = "./data")

# Read in column names of data
featureNames <- read.table("./data/UCI HAR Dataset/features.txt")
featureNames <- featureNames[,2]

# Read in train and test data
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
combinedData <- rbind(trainData, testData)
colnames(combinedData) <- featureNames

meanStandardDeviationData <- combinedData[,grep("mean|std",names(combinedData))]

# Read in test and train activity labels
trainActivity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
testActivity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
combinedActivity <- rbind(trainActivity, testActivity)
colnames(combinedActivity) <- c("activityCode")

# Read in test and train subject ids
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
combinedSubject <- rbind(trainSubject, testSubject)
colnames(combinedSubject) <- c("subjectId")

# Generate Sequences to join the means, activities, and subjects
meanStandardDeviationData$activityId <- seq.int(nrow(meanStandardDeviationData))
combinedActivity$activityId  <- seq.int(nrow(meanStandardDeviationData))
combinedSubject$activityId <- seq.int(nrow(meanStandardDeviationData))

# Merge means and activities
activityMeansData <- merge(combinedActivity
                           , meanStandardDeviationData
                           , by.x = "activityId"
                           , by.y = "activityId"
                           , all = TRUE)

# Load and merge activity labels against the activity codes
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels)<- c("activityCode","activityLabel")
activityMeanData <- merge(
    activityMeansData
    , activityLabels
    , by.x = "activityCode"
    , bby.y = "activityCode"
    , all = TRUE
)
activityMeanData <- activityMeanData[,c(1,2,82,3:81)]

# Merge activity with means and subjects
subjectActivityMeansData <- merge(combinedSubject
                                  , activityMeanData
                                  , by.x = "activityId"
                                  , by.y = "activityId"
                                  , all = TRUE)

# Melt data in preparation to generate a tidy data set of averages
finalData <- subjectActivityMeansData[,c(2,4:83)]
meltFinalData <- melt(finalData, id = c("subjectId", "activityLabel"))

# Generate a tidy data set and write to file
tidyData <- ddply(meltFinalData,.(subjectId, activityLabel, variable), summarize, variableAverage=mean(value))
write.table(tidyData, file="./data/activity_means.txt", row.names = FALSE)
