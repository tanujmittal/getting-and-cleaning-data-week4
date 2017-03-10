# getting-and-cleaning-data-week4

## Human Activity Recognition using Smartphone Dataset processing Script

Dataset Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script "run_analysis.R" takes UCI HAR Dataset available at the mentioned URL and gives out a clensed and consolidated dataset as opposed to fragmented dataset in the original source set which is spread across mutliple files.

The script assumes a specific directory structure as detailed in comments in the script will get created once the data set is downloaded and unzipped.

The scripts takes the following approach:

1. Ensure the required packages (dplyr, reshape2) are installed.
2. Download and unzip the file to get the raw files.
3. Read the test data set observations from X_test.txt, y_test.txt, subject_test.txt and combine these into a single data frame. 
4. Set a new study type column in the dataframe to add information to the data set that allows us to filter on test vs. training data.
5. Repeat these steps for the training data set.
6. Merge the two datasets into a single dataframe using rbind()
7. Give descripting names to the columns. This fulfills Objective 3.
8. This results in mergedDs which fulfills Objective 1.
9. Subset mergedDs using grepl in the column position to get meanStdCols. This fulfills Objective 2.
10. Apply factors on the activity label column to get descriptive names for the activities. This fulfills Objective 4.
11. Use melt to flatten the mergedDs on key columns Activity and Subject.
12. Use dcast along with mean funciton to widen the mergedDs and calculate the means of all of the variables.
13. This gives meansBySubActivityDs which fulfills Objective 5.
14. Export mergedDs and meansBySubActivityDs so that they be saved to flatfile and uploaded on github.
