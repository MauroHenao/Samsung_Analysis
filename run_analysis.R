#Libraries:
library(plyr)
library(reshape2)

#Uploading data
x_test = read.table("./UCI HAR Dataset/test/X_test.txt")
x_train = read.table("./UCI HAR Dataset/train/X_train.txt")
features = read.table("./UCI HAR Dataset/features.txt")
activity = read.table("./UCI HAR Dataset/activity_labels.txt")
y_test = read.table("./UCI HAR Dataset/test/y_test.txt")
y_train = read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttest= read.table("./UCI HAR Dataset/test/subject_test.txt")
subjecttrain= read.table("./UCI HAR Dataset/train/subject_train.txt")


#Merging x_test and x_train. Giving names to columns
x_test_train<- rbind(x_test,x_train)
colum=as.character(features[[2]])
names(x_test_train)=colum

#Getting only mean and standar desviation variables
msfeatures=grep("mean|std",colum)
x_test_train=x_test_train[,msfeatures]


#Merging y_test and y_train
y_test_train<- rbind(y_test,y_train)
names(y_test_train)="ID_Activity"

#Merging subjecttest and subjecttrain
subject=rbind(subjecttest,subjecttrain)
names(subject)="subject"

#Merging x_test_train and y_test_train
xy_test_train<-cbind(x_test_train,y_test_train,subject)

#Naming the variables of activity
names(activity)=c("NumberAct","Act")

#Stablishing the names of each activity
xy_test_train=merge(xy_test_train,activity,by.x = "ID_Activity",by.y = "NumberAct",all=T)

id_labels   = c("subject", "ID_Activity", "Act")
data_labels = setdiff(colnames(xy_test_train), id_labels)
melt_data      = melt(xy_test_train, id = id_labels, measure.vars = data_labels)

tidy_data   = dcast(melt_data, subject + Act ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.names=FALSE)
