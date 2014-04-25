#Download file, unzip and read data into memory
setwd("~")
getwd()
library(stringr)
if (!file.exists("data")){
  dir.create("data")
}
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="sensor.zip",method="curl")
dateDownlaoded<-date()
dateDownlaoded
unzip("sensor.zip", overwrite=T, exdir="data",unzip="internal")
X<-read.table("./data/UCI HAR Dataset/test/X_test.txt",header=F,sep="")
Y<-read.table("./data/UCI HAR Dataset/train/X_train.txt",header=F,sep="")
#rbind test and training data
Z<-rbind(X,Y)
#get features and filter out any that is not a mean and std deviation of measurements
#keep both the indicators and the feature names
con<-file("./data/UCI HAR Dataset/features.txt")
col_labels<-readLines(con)
close(con)
n_col_labels<-gsub("meanFreq()","",col_labels)
means_kept_i<-grep("-mean()",n_col_labels)
means_kept<-col_labels[means_kept_i]
std_kept_i<-grep("-std()",n_col_labels)
stds_kept<-col_labels[std_kept_i]
#i_kept are the indices kept
i_kept<-c(means_kept_i,std_kept_i)
names_kept<-c(means_kept,stds_kept)
#subject for only chosen features
Z_t<-subset(Z,select=i_kept)
# read y and subject data for test and training set and combine them
con<-file("./data/UCI HAR Dataset/train/y_train.txt")
y<-readLines(con)
close(con)
con<-file("./data/UCI HAR Dataset/train/subject_train.txt")
sub<-readLines(con)
close(con)
con<-file("./data/UCI HAR Dataset/test/y_test.txt")
y2<-readLines(con)
close(con)
con<-file("./data/UCI HAR Dataset/test/subject_test.txt")
sub2<-readLines(con)
close(con)
y3<-c(y2,y)
sub3<-c(sub2,sub)
#cbind activity, then subject to measurement data
Z_t<-cbind(y3,Z_t)
Z_t<-cbind(sub3,Z_t)
#add "subject" and "activity" to col_labels which comes from features.txt
labels<-c("subject","activity")
Z_colnames<-c(labels,names_kept)
#set column names of extracted data set
colnames(Z_t)<-Z_colnames
#map numerical values in $activity to descriptive labels
library(plyr)
Z_t$activity<-mapvalues(Z_t$activity, from = c("1","2","3","4","5","6"),to=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
#Melt data set and recast with subject and activity as ID's and apply mean function on all measurements grouped by ID's
library(reshape2)
molten<-melt(Z_t, id=c("subject","activity"))
tidy<-dcast(molten, formula=subject+activity~variable, mean)
write.table(tidy,"./data/tidy.txt", sep="\t",col.names=T)
