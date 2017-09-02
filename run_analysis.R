

library(data.table)
library(dplyr)

# Load: activity labels
act_lvl <- read.table("./activity_labels.txt")[,2]

# Load: data column names
feature <- read.table("./features.txt")[,2]

#select columns names only for means and standard deviation
mean_std_features <- grepl("mean|std", feature)

#Load and process X and Y training data
x_train<- read.table("./train/X_train.txt")
names(x_train) = feature
x_mean_std_train <- x_train[,mean_std_features]

y_train<- read.table("./train/y_train.txt")
y_train[,2] = act_lvl[y_train[,1]]
names(y_train)<- c("activity_id","activity_label")

sub_train<- read.table("./train/subject_train.txt")
names(sub_train) = "subjects"

# Extract data only forthe mean and standard deviation for each measurement.
train_data <- cbind(as.data.table(sub_train),y_train, x_mean_std_train)


#Load and process X and Y test data
x_test<- read.table("./test/X_test.txt")
names(x_test) = feature
x_mean_std_test <- x_test[,mean_std_features]

y_test<- read.table("./test/y_test.txt")
y_test[,2] = act_lvl[y_test[,1]]
names(y_test)<- c("activity_id","activity_label")

sub_test<- read.table("./test/subject_test.txt")
names(sub_test) = "subjects"


test_data <- cbind(as.data.table(sub_test),y_test, x_mean_std_test)

#combine test and training data
data<-rbind(train_data,test_data)


tidy data set with the average of each variable for each activity and each subject
means = data %>% group_by(activity_label,subjects) %>% summarize_all(funs(mean))

write.table(means, file = "./tidy_data.txt",row.name=FALSE)
