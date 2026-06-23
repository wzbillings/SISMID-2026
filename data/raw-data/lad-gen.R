set.seed(123)

# Generate 30 x values uniformly spaced
n <- 30
x <- sort(runif(n, -10, 10))

# Base y values from a linear trend + normal noise
y <- 2 * x + 1 + rnorm(n, sd = 2)

# Introduce a few strong outliers (e.g., 4 points)
outlier_indices <- c(1, 2, 10)
y[outlier_indices] <- y[outlier_indices] +
	rnorm(length(outlier_indices), mean = 25, sd = 3)  # Large positive outliers

outlier_indices <- c(15, 23, 24, 28)
y[outlier_indices] <- y[outlier_indices] +
	rnorm(length(outlier_indices), mean = -25, sd = 3)  # Large negative outliers

# Put into a data.frame
dat <- data.frame(x = x, y = y)

# Optional: visualize
plot(dat$x, dat$y, xlab = "x", ylab = "y", pch = 19)
abline(lm(y ~ x, data = dat), col = "blue", lwd = 2, lty = 2)  # OLS
abline(quantreg::rq(y ~ x, data = dat), col = "red", lwd = 2)  # LAD

legend("topleft", legend = c("OLS", "LAD"), col = c("blue", "red"),
			 lty = c(2, 1), lwd = 2)

write.table(
	dat,
	here::here("data", "lad.txt"),
	row.names = FALSE
)
