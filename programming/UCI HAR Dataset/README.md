

The program run_analysis.R implements the course project for the "Getting and Cleaning data" Coursera lecture by Jeff Leek, Roger D. Peng, and Brian Caffo on Coursera.

The code book for the variables in the resulting data set is in codebook.txt.

The run_analysis.R script realizes the 5 steps of the project in order. It assumes the data containing folders are in the working directory. 

The date is read from the sources, merged, and named with appropriate names found in specific data files. The relevant variables are selected from the data, and more descriptive names are given to those variables.

The final dataset is written to tidy_means.txt.