# Getting and Cleaning Data Course Project
This file describes how run_analysis.R script works.

1. Clone complete GIT include "data" folder
2. Run RStudio
3. Set working directory in R to the cloned GIT folder.
4. Open "run_analysis.R" command in RStudio.
5. Load "run_analysis.R" into RStudio context by icon "Source" or by command "source('run_analysis.R')"
6. Run analysis by command "run()"
7. You will find two output files in the current working directory
	merged_data.txt - it contains a data frame called cleanedData
	data_with_means.txt - it contains a data frame called result
8. Finally, use data <- read.table("data_with_means.txt") command in RStudio to read the file. Since we are required to get the average of each variable for each activity and each subject, and there are 6 activities in total and 30 subjects in total, we have 180 rows with all combinations for each of the 66 features.
