Getting-Data-Class-Project
==========================

Documentation for cleaning sensor data

Getting and Cleaning Data Project
========================================================

Documentation for this project include

1. README.md - this document in the github repo

2. run_analysis.R - in the github repo

3. code_book.md - in the github repo

4. tidy.txt - uploaded to Coursera site

This project creates a data folder in the user's home directory: ~/data

Input data is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
into a file named sensor.zip in the user's home directory: ~/sensor.zip

Unzipped data is located in a folder named "UCI HAR Datset" in ~/data.  

run_analysis.R gets, extracts, transforms the input data.  It loads the output tidy data set as "tidy.txt" into ~/data.  

code_book.md provides detailed comments on the extract-transform-load process.
