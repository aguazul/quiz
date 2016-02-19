# Data Validation Report Generator Script
# This script imports data from the .csv files and fills in any missing dates
# It creates a flag where consent date is after the sample collection date
# Then it exports the final report as a .csv file
# Brandon Bosse
# 2/16/2016

# Use the sqldf Package
library(sqldf)

# Use the CompletePartialDate function
 source("CompletePartialDate.R")

# Read the .csv files from the data folder using a relative path
# These files are stored in a data.frame object
Exam_dates <- read.csv(file=file.path("data", "exam_dates.csv"))
Consents <- read.csv(file=file.path("data", "consents.csv"))
Collection <- read.csv(file=file.path("data", "collection.csv"))

# Select the desired rows from the 3 tables
resultSet = sqldf("SELECT Exam_dates.patient_id, Exam_dates.visit_id, Exam_dates.date, Consents.date, Collection.type, Collection.is_collected
			 FROM (Exam_dates INNER JOIN Collection ON (Exam_dates.visit_id = Collection.visit_id) AND (Exam_dates.patient_id = Collection.patient_id)) LEFT JOIN Consents ON Exam_dates.patient_id = Consents.patient_id
			 WHERE Collection.type='blood' 
			 ORDER BY Exam_dates.patient_id")

# Add a 'flag' column to the result set
resultSet$flag <- FALSE

# Loop through all the rows of the result set
for (i in 1:nrow(resultSet)) {
	
	# Extract the date values for this i row
	xDate <- resultSet[i,3] # Exam date is in column 3
	cDate <- resultSet[i,4] # Consent date is in column 4
	
	# Some patients do not have a consent on file.
	if (is.na(cDate)) {
		cDateObj = NA
	} else {	
		cDateObj = as.Date(cDate)
	}

	# Check if the xDate is partial
	if (substr(xDate, 9, 10)=="XX") {
		xDateObj = CompletePartialDate(xDate)
		resultSet[i,3] = as.character(xDateObj)
	} else {
		xDateObj = as.Date(xDate)
	}

	# Flag each record where the blood sample was collected AND the consent date was after the collection date
	if (resultSet[i,6]==1 & (cDateObj > xDateObj | is.na(cDateObj))) { # is_collected is in column 6
		resultSet[i,7] = TRUE # Flag is in column 7
	}
}

# Finally save the result set as a new .csv file
write.csv(resultSet, file = "resultSet.csv")

