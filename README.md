# coursera_data_cleaning_project
My course project for the Data Cleaning class on Coursera

The run_analysis.R script downloads the UCI Samsung wearbles data archive, decompresses it, and generates a tidy 
output file with the averages of the measured variables per subject per activity.

This script uses the base, reshape2, and plyr libraries.

The script starts by downloading the zip file and places it into a data subdirectory. It starts by reading in the test and training data in the "X" files found in the respective test and train subdirectories. These two data sets are concatenated using rbind. The variable names are applied to the combined data.frame from a vector loaded from the features.txt file. The grep function is used against a vector of the data frames names to filter for variables that are means or standard deviations. This grep generates a logcial vector, which is used to subset the columns.

Next the rbind process is repeated for the activity codes from the "y" files, making sure to concatenate in the same order as the "X" files. A variable name "activityCode" is applied.

Third, the same rbind process is performed against the "subject files that contain IDs for the participants in the study. A variable name "subjectId" is applied.

In order to merged these three sets together, sequences are appended to all 3 data frames with a variable name of activityId. Then, the means and standard deviations are merged/joined with the activity codes. The labels for the activity codes are loaded and then merged to append a factor column. The columns are reordered to put related activity variables at the start of the data frame.

The last merge joins the subject ids to the combined data set. The activityId and activityCode variables are filtered out of the data frame as they are no longer needed, now the join is complete. This leaves a data frame with rows identified by the subjectId and the activityLabel. The melt function from the reshape2 library is applied to generate a tall skinny data set. 

This tall skiny data set is run through the ddply function from the plyr library to apply the mean function across subjectId, activityLabel, and variable name to generate the averages. These results are written to a file in the data subdirectory called activity_means.txt.

Source Project Website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


