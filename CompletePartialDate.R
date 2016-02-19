# CompletePartialDate Function
# Accepts partial dates as a character vector
# Allows user to specify a day value and replaces missing days with this value. If the user doesn't specify it uses the default of 15 for the day.
# Returns the completed date as an object
# Brandon Bosse
# 2/16/2016

CompletePartialDate <- function(partialDate) {
	# y is the YEAR of the partial date
	y = substr(partialDate,1,4)
	# m is the MONTH of the partial date
	m = substr(partialDate,6,7)
	# d is the DAY value specified by the user (or will be 15 if the user doesn't enter anything)
	d = NA

	# Maximum DAY value for each MONTH
	maxDay = c(31,29,31,30,31,30,31,31,30,31,30,31)

	while (is.na(d)) {
		d <- readline(prompt= paste(partialDate, "is incomplete. Enter a DAY value or press ENTER for 15:"))
		if (d=="") { #The user did not enter a value.  Use default of 15.
			d = "15"
		} else if (!grepl("^[0-9]+$",d)){ #The user entered a value that was not a number
			print("The value you entered was not a number.")
			d = NA
		} else if (as.integer(d) < 1 | as.integer(d) > maxDay[as.integer(m)]) { # the user entered a value that is not a possible day value
			print(paste("The day value must be between 1 and", maxDay[as.integer(m)]))
			d = NA
		}
	}
	# Concat the completed date elements together as YYYY-MM-DD
	completedDate = paste(y,m,d,sep="-")

	# Finally return the completed date vector as a Date object
	return(as.Date(completedDate))
}
