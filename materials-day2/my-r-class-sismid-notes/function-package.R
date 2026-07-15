###
# Functions
###

times_two <- function(x) x*2

times_two(4)
times_two(9)

times_two(1:10)

# Assign x3 in the "global scope" -- it can be seen
# by any code in this file (and accessed)
x3 <- 14

times_three <- function(x) {
  #x3 is in the "local" scope of the function
  # It is temporary
  x3 <- x * 3
  
  return(x3)
}

y <- times_three(7)

collatz <- function(n) {
  if (n %% 2 == 0) {
    # This code will only run if the condition is TRUE
    return(n / 2)
  } else if (n %% 2 == 1) {
    return(3 * n + 1)
  } else {
    return("Uh oh")
  }
}

collatz(14)
collatz(7)
collatz(22)
collatz(collatz(14))

n <- 14
i <- 1
while (n > 1) {
  cat("Iteration ", i, ": ")
  n <- collatz(n)
  i <- i + 1
  cat(n, "\n")
}

# Load our count_collatz_iterations() function
source("count_collatz_iterations.R")

count_collatz_iterations(14)
# Same as this
count_collatz_iterations(14, verbose = FALSE)


count_collatz_iterations(14, verbose = TRUE)
count_collatz_iterations(67, verbose = TRUE)

y <- count_collatz_iterations(14, verbose = FALSE)
z <- count_collatz_iterations(14, verbose = TRUE)

# THese error because "if" is not vectorized
collatz(1:10)
count_collatz_iterations(1:10)



# Test this on a bunch of numbers
my_numbers <- seq(2, 25, 1) # same as 2:25
for (i in my_numbers) {
  print(count_collatz_iterations(i))
}
