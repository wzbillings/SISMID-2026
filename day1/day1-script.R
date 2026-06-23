ssd <- function(x) {
	# Calculate the x_i - x_bar
	x_no_missing <- na.omit(x)
	x_bar <- mean(x_no_missing)
	differences <- x_no_missing - x_bar
	
	# Next square all of the differences
	squared_differences <- differences ^ 2
	
	# And then get the sum of the squared differences
	sum_sq_differences <- sum(squared_differences)
	return(sum_sq_differences)
}

debugonce(ssd)

ssd(meas$measles_cases)








x <- 12
divider <- function(x) {
  this <- x/4
  return(this)
}

divider(22)


