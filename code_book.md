Getting and Cleaning Data Project
========================================================
First set up ~/data directory on local host. 
Download the zip file from the class website onto the home directory and unzip the file into the ~/data folder


```r
# Download file, unzip and read data into memory
setwd("~")
getwd()
```

```
## [1] "/Users/raphaeltam"
```

```r

library(stringr)
if (!file.exists("data")) {
    dir.create("data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "sensor.zip", method = "curl")
dateDownlaoded <- date()
dateDownlaoded
```

```
## [1] "Fri Apr 25 14:24:57 2014"
```

```r
unzip("sensor.zip", overwrite = T, exdir = "data", unzip = "internal")
```

Read data into memory and combine test and training data

```r
setwd("~")
X <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = F, sep = "")
Y <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = F, sep = "")
# rbind test and training data
Z <- rbind(X, Y)
Z[1:5, 1:7]
```

```
##       V1       V2       V3      V4      V5      V6      V7
## 1 0.2572 -0.02329 -0.01465 -0.9384 -0.9201 -0.6677 -0.9525
## 2 0.2860 -0.01316 -0.11908 -0.9754 -0.9675 -0.9450 -0.9868
## 3 0.2755 -0.02605 -0.11815 -0.9938 -0.9699 -0.9627 -0.9944
## 4 0.2703 -0.03261 -0.11752 -0.9947 -0.9733 -0.9671 -0.9953
## 5 0.2748 -0.02785 -0.12953 -0.9939 -0.9674 -0.9783 -0.9941
```

For this analysis, only measurements with -mean() and -std() at the end of the names are kept.  These are the mean and standard deviations calculated from the sensor data.  Features with mean or std in their names are discarded because I assume they are not from calculations.  There are 10299 observations and 66 variables.

```r
# get features and filter out any that is not a mean and std deviation of
# measurements keep both the indicators and the feature names
setwd("~")
con <- file("./data/UCI HAR Dataset/features.txt")
col_labels <- readLines(con)
close(con)
n_col_labels <- gsub("meanFreq()", "", col_labels)
means_kept_i <- grep("-mean()", n_col_labels)
means_kept <- col_labels[means_kept_i]
std_kept_i <- grep("-std()", n_col_labels)
stds_kept <- col_labels[std_kept_i]
# i_kept are the indices kept
i_kept <- c(means_kept_i, std_kept_i)
names_kept <- c(means_kept, stds_kept)
# subject for only chosen features
Z_t <- subset(Z, select = i_kept)
dim(Z_t)
```

```
## [1] 10299    66
```

Combine activity and subject data from y_train, subject_train, y_test and subject_test files.  Combine this data
with the measurements to produce 10299 observations with 68 variables.  Set the variable names for the data set 
by combining "subject", "activity" with the names from features.txt

```r
# read y and subject data for test and training set and combine them
setwd("~")
con <- file("./data/UCI HAR Dataset/train/y_train.txt")
y <- readLines(con)
close(con)
con <- file("./data/UCI HAR Dataset/train/subject_train.txt")
sub <- readLines(con)
close(con)
con <- file("./data/UCI HAR Dataset/test/y_test.txt")
y2 <- readLines(con)
close(con)
con <- file("./data/UCI HAR Dataset/test/subject_test.txt")
sub2 <- readLines(con)
close(con)
y3 <- c(y2, y)
sub3 <- c(sub2, sub)
# cbind activity, then subject to measurement data
Z_t <- cbind(y3, Z_t)
Z_t <- cbind(sub3, Z_t)
# add 'subject' and 'activity' to col_labels which comes from features.txt
labels <- c("subject", "activity")
Z_colnames <- c(labels, names_kept)
# set column names of extracted data set
colnames(Z_t) <- Z_colnames
Z_t[1:5, 1:7]
```

```
##   subject activity 1 tBodyAcc-mean()-X 2 tBodyAcc-mean()-Y
## 1       2        5              0.2572            -0.02329
## 2       2        5              0.2860            -0.01316
## 3       2        5              0.2755            -0.02605
## 4       2        5              0.2703            -0.03261
## 5       2        5              0.2748            -0.02785
##   3 tBodyAcc-mean()-Z 41 tGravityAcc-mean()-X 42 tGravityAcc-mean()-Y
## 1            -0.01465                  0.9365                 -0.2827
## 2            -0.11908                  0.9274                 -0.2892
## 3            -0.11815                  0.9299                 -0.2875
## 4            -0.11752                  0.9289                 -0.2934
## 5            -0.12953                  0.9266                 -0.3030
```

Change numerical values in $activity to descriptive labels, melt and dcast melted data to group by subject
and activity.  Calculate mean of measurements by subject-activity.
Write tidy data set to disk and to be submitted to Coursera

```r
# map numerical values in $activity to descriptive labels
setwd("~")
library(plyr)
Z_t$activity <- mapvalues(Z_t$activity, from = c("1", "2", "3", "4", "5", "6"), 
    to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", 
        "LAYING"))
# Melt data set and recast with subject and activity as ID's and apply mean
# function on all measurements grouped by ID's
Z_t[1:5, 1:7]
```

```
##   subject activity 1 tBodyAcc-mean()-X 2 tBodyAcc-mean()-Y
## 1       2 STANDING              0.2572            -0.02329
## 2       2 STANDING              0.2860            -0.01316
## 3       2 STANDING              0.2755            -0.02605
## 4       2 STANDING              0.2703            -0.03261
## 5       2 STANDING              0.2748            -0.02785
##   3 tBodyAcc-mean()-Z 41 tGravityAcc-mean()-X 42 tGravityAcc-mean()-Y
## 1            -0.01465                  0.9365                 -0.2827
## 2            -0.11908                  0.9274                 -0.2892
## 3            -0.11815                  0.9299                 -0.2875
## 4            -0.11752                  0.9289                 -0.2934
## 5            -0.12953                  0.9266                 -0.3030
```

```r
library(reshape2)
molten <- melt(Z_t, id = c("subject", "activity"))
tidy <- dcast(molten, formula = subject + activity ~ variable, mean)
tidy[1:10, 1:7]
```

```
##    subject           activity 1 tBodyAcc-mean()-X 2 tBodyAcc-mean()-Y
## 1        1            WALKING              0.2773           -0.017384
## 2        1   WALKING_UPSTAIRS              0.2555           -0.023953
## 3        1 WALKING_DOWNSTAIRS              0.2892           -0.009919
## 4        1            SITTING              0.2612           -0.001308
## 5        1           STANDING              0.2789           -0.016138
## 6        1             LAYING              0.2216           -0.040514
## 7       10            WALKING              0.2786           -0.017022
## 8       10   WALKING_UPSTAIRS              0.2671           -0.014385
## 9       10 WALKING_DOWNSTAIRS              0.2904           -0.020005
## 10      10            SITTING              0.2706           -0.015043
##    3 tBodyAcc-mean()-Z 41 tGravityAcc-mean()-X 42 tGravityAcc-mean()-Y
## 1              -0.1111                  0.9352                -0.28217
## 2              -0.0973                  0.8934                -0.36215
## 3              -0.1076                  0.9319                -0.26661
## 4              -0.1045                  0.8315                 0.20441
## 5              -0.1106                  0.9430                -0.27298
## 6              -0.1132                 -0.2489                 0.70555
## 7              -0.1091                  0.9631                -0.08383
## 8              -0.1182                  0.9319                -0.05657
## 9              -0.1108                  0.9398                -0.06462
## 10             -0.1043                  0.7919                -0.04126
```

```r
write.table(tidy, "./data/tidy.txt", sep = "\t", col.names = T)
```

