count_collatz_iterations <- function(n, verbose = FALSE) {
    i <- 0
    while (n > 1) {
      if (verbose)
        cat("Iteration ", i, ": ")
      i <- i + 1
      n <- collatz(n)
      if (verbose)
        cat(n, "\n")
  }
  
  if (verbose) {
    # Side effect mode
    invisible(i)
  } else {
    # Return value mode
    return(i)
  }
}

# sqdif function
sqdif <- function(x = 2, y = 3) {
  diff <- x - y
  sq_diff <- diff ^ 2
  
  return(sq_diff)
}

sqdif(5, 7)
sqdif()
sqdif(x = 6)
sqdif(y = 900)

sqdif(1:10, 2:11)

# Our function is auto-vectorized
# because we only used vectorized base R functions in the def
# So what is happening here when the vectors have different lengths?
sqdif(1:10, c(7, 4))

# The vectorized operation basically does
# sqdif(1, 7)
# sqdif(2, 4)
# and then the second vector gets RECYCLED
# sqdif(3, 7)
# sqdif(4, 4)

# We get a warning about recycling if the shorter vector's
# length does not divide the longer vector length
sqdif(1:10, c(21, 30, 4))

# By the time we get to the call
# sqdif(10, 21)
# We are not at the end of the second vector
# so R wants us to know we may be recycling incorrectly

# Recycling can be very useful too
sqdif(seq(7, 433, 4), 984)

# Geometric mean #### or ---- or ====
geo_mean <- function(x) {
  output <- exp(mean(log(x)))
  return(output)
}

geo_mean(c(2, 3, 4, 5))

# We can make a version that takes any amount of numbers
geo_mean <- function(...) {
  x <- c(...)
  output <- exp(mean(log(x)))
  return(output)
}

geo_mean(2, 3, 4, 5)

# The tidyverse people like to write functions like this
geo_mean_impl <- function(x) {
  output <- exp(mean(log(x)))
  return(output)
}

geo_mean <- function(...) geo_mean_impl(c(...))
geo_mean(2, 3, 4, 5)
geo_mean_impl(c(2, 3, 4, 5))
