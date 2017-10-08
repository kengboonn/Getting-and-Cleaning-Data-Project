#load library
library(dplyr)
library(reshape2)
#intialize frame
mydf<-data.frame()

#read data...
train_sub <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
test_sub <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
train_x<- read.table ("./UCI HAR Dataset/train/X_train.txt")
test_x <- read.table ("./UCI HAR Dataset/test/X_test.txt")
train_y<- read.table ("./UCI HAR Dataset/train/Y_train.txt")
test_y <- read.table ("./UCI HAR Dataset/test/Y_test.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#merge data...
X<-rbind(train_x,test_x)
Y<-rbind(train_y,test_y)
subject <-rbind(train_sub,test_sub)
Y[,2] = activity_labels[Y[,1]]

#label data...
colnames(subject) <- c("SubjectID")
features<-read.table("./features.txt")%>%
  select(2)
  features<-t(features)
colnames(X)<-features
colnames(Y) <- c("ActivityID", "Activity")

#form database...
mydf<- cbind(subject,Y,X)

#remove unnecessary data...
rm(train_sub,test_sub,train_x,test_x,train_y,test_y,activity_labels,features,subject,X,Y)

#subset mydf ...
mydf<-mydf[,grep("SubjectID|ActivityID|Activity|mean|std",names(mydf))]

#reshaping and aggregating....
reshape_mydf<-melt(mydf,id=c("SubjectID","ActivityID","Activity"),measure.var = grep("mean|std",names(mydf)))
tidy_mydf<-dcast(reshape_mydf, SubjectID + ActivityID +Activity ~ variable,mean)

#remove unnecessary data...
rm(mydf,reshape_mydf)

