# Generate SIR case count data

set.seed(101)
sir_parms <- c(beta = 0.001, gamma = 0.05)
t_seq <- seq(0, 100, 1)
n <- length(t_seq)
sir_initial_condition <- c(S = 1000, I = 1, R = 0)
sir_ode <- function(t, y, parameters) {
	# If you don't use with() you have to do this
	b <- parameters["beta"]
	g <- parameters["gamma"]
	
	S <- y["S"]
	I <- y["I"]
	R <- y["R"]
	
	dS <- -b * I * S
	dI <- b * I * S - g * I
	dR <- g * I
	
	# For deSolve the output always has to be a list like this
	out <- list(c(dS, dI, dR))
	return(out)
}
sir_soln <- deSolve::ode(
	y = sir_initial_condition,
	times = t_seq,
	func = sir_ode,
	parms = sir_parms
)

total_cases <- sir_soln[2:101,"I"]
observed_cases <- rnbinom(length(total_cases), mu = total_cases, size = 100)
observed_cases[1] <- 1
observed_cases[n-2] <- 3
observed_cases[n-1] <- 0

obs_dat <- data.frame(
	day = 1:length(observed_cases),
	total_cases = observed_cases
)

plot(obs_dat$day, obs_dat$total_cases, type = "b", xlab = "day", ylab = "cases")
lines(obs_dat$day, total_cases, type = "l", lty = 2, col = "red")

write.csv(
	obs_dat,
	here::here("data", "SIR-observed.csv"),
	row.names = FALSE
)
