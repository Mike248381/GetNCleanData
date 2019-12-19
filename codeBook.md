# These are all the steps I went through to arrive at the final dataset. You can also read them directly from comments in the code

1. I read in the data (training_data, test_data, activity labels, subjects) with read.table("file name")

2. I used a two-step grep function to select only data with mean() and std(). The second part was important to eliminate meanfreq() since I didn't want that.

3. From there, I used rbind() and cbind() to merge all the training and test data by rows and to the subject and activity data by the column

4. The subject and activity columns are integers, so I used as.factor() to convert them to factors.

5. I passed in levels() to assign descriptive labels instead of numbers to the activity as in the code below:
levels(my_full_data$activity_id)[c(1,2,3,4,5,6)] <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")

6. After this comes the last step to find the averages of all columns by subject and activity. I used group_by() to group data by the two factor variables, and summarized with a mean function.

