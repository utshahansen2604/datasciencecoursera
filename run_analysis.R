#----------- UTSHAHAN SEN----------





library(plyr)
library(data.table)

#Path to the dataset
setwd("C:\\Users\\my\\Documents\\R\\Getting and Cleaning Data\\Downloaded Files\\FUCI HAR Dataset\\UCI HAR Dataset")


#Loading and reading dataset
subTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

#Combining into a single data set

xDS <- rbind(xTrain, xTest)
yDS <- rbind(yTrain, yTest)
subDS <- rbind(subTrain, subTest)

#Extracting only mean and standard deviation based on logical vector
xDS_mean_std <- xDS[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDS_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 

yDS[, 1] <- read.table("activity_labels.txt")[yDS[, 1], 2]
names(yDS) <- "Activity"
names(subDS) <- "Subject"


# Defining the data with appropiate labels

singleDS <- cbind(xDS_mean_std, yDS, subDS)
names(singleDS) <- make.names(names(singleDS))
names(singleDS) <- gsub('Acc',"Acceleration",names(singleDS))
names(singleDS) <- gsub('GyroJerk',"AngularAcceleration",names(singleDS))
names(singleDS) <- gsub('Gyro',"AngularSpeed",names(singleDS))
names(singleDS) <- gsub('Mag',"Magnitude",names(singleDS))
names(singleDS) <- gsub('^t',"TimeDomain.",names(singleDS))
names(singleDS) <- gsub('^f',"FrequencyDomain.",names(singleDS))
names(singleDS) <- gsub('\\.mean',".Mean",names(singleDS))
names(singleDS) <- gsub('\\.std',".StandardDeviation",names(singleDS))
names(singleDS) <- gsub('Freq\\.',"Frequency.",names(singleDS))
names(singleDS) <- gsub('Freq$',"Frequency",names(singleDS))



#Data2 is a second independent dataset

Data2<-aggregate(. ~Subject + Activity, singleDS, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)





#---------------------------------------------------