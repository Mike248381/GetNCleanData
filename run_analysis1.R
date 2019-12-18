-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
# READING IN DATA

y_train <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/train/y_train.txt") # activities in training data (numbered)
X_train <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/train/X_train.txt") # Read all 561 columns
train_subj <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/train/subject_train.txt")
y_test <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/test/y_test.txt") # activities in test data (numbered)
X_test <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/test/X_test.txt") # Read all 561 columns
test_subj <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./JohnsHopkins1/Data/UCI HAR Dataset/activity_labels.txt")  # labels for the numbered activities above

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

# SELECTING ALL COLUMNS WITH mean() and std(). 
  
#Went a bit roundabout to select all the necessary columns but just follow me
  
sel <- c("mean()", "std()")
cols <- grep(paste(sel, collapse="|"), features$V2) # selects all columns with std and mean.
# Unfortunately, picks up meanfreq(). Don't want that, so I am going to remove them below

features <- features[cols,]  # selecting indexes and names of all mean() and std()
features
cols_sub <- grep("Freq", features$V2)  # selecting indexes and names of all columns with Freq to eliminate in the next step
features <- features[-cols_sub, ]  # Now, we are left with only the columns with mean() and std() without the meanfreq

cols_int <- features$V1  # indexes of selected variables
col_names <- features$V2 # names of selected variables

X_train <- X_train[, cols_int] # Select necessary columns from X_train based on the column indexes
X_test <- X_test[, cols_int] # Select necessary columns from X_test based on the column indexes

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------  

# PUT ALL THE TEST AND TRAIN DATA TOGETHER
  
full_X <- rbind(X_train, X_test)
full_y <- rbind(y_train, y_test)
full_sub <- rbind(train_subj, test_subj)

colnames(full_X) <- col_names    ## Assign column names to all selected columns
colnames(full_sub) <- "subject"  ## Assign column name to the subjects data
colnames(full_y) <- "activity id" ## Assign column name to the activities data

full_data <- cbind(full_sub, full_X)  # Combine subjects with all other variables
full_data <- cbind(full_data, full_y) # combine the resulting data from previous step with all the labels column

str(full_data)  # shows subject and activity_id columns are integers but we want to make them factors
# Before that, I will first want to use dplyr functionality convert my data to tbl_df

library(dplyr)
my_full_data <- tbl_df(full_data) # changed dataframe format

names(my_full_data)[68] <- "activity_id"  # removing the space in the "activity id" with an "_"

my_full_data$activity_id <-as.factor(my_full_data$activity_id)  # transforms the activity to factor instead of integer
my_full_data$subject <- as.factor(my_full_data$subject)   # transforms subjects to factor instead of integer

#assign activity_id column with labels
levels(my_full_data$activity_id)[c(1,2,3,4,5,6)] <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")

my_full_data # This now has all the columns (subjects, mean(), std(), and activities with labels)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

# INDEPENDENT TIDY DATA SET WITH AVERAGE OF EACH VARIABLE FOR EACH SUBJECT 
  
subj_act_mean <- summarise_all(group_by(my_full_data, .dots = c("subject", "activity_id")), mean) #group_by(my_full_data, activity_id) and summarize by mean
subj_act_mean  # 180 rows (6activities * 30 subjects)

write.table(subj_act_mean, "tidy_data.txt", sep = ",", row.names = FALSE)

