# Statistical Modeling and Simulation Project
# Topic: Linear Regression Modeling using Bootstrap Simulation
# Field: Business and Economics
# Model: Monthly Sales Revenue ~ Advertising Budget + Product Price

# ---------------------------------------------------------
# 0. Setup and Library Loading
# ---------------------------------------------------------
library(ggplot2)
library(boot)

# Set seed for exact reproducibility of the simulation
set.seed(42)

# ---------------------------------------------------------
# 1. Generate an Initial "Real-world" Base Dataset
# ---------------------------------------------------------
n_base <- 50
advertising_budget <- runif(n_base, min = 10, max = 100) # Budget ($10k to $100k)
product_price <- runif(n_base, min = 20, max = 150)      # Price ($20 to $150)

# True underlying economic parameters
beta_0 <- 500  
beta_1 <- 5    
beta_2 <- -2   

# Generate the dependent variable (Sales) with random noise
error_term <- rnorm(n_base, mean = 0, sd = 40)
sales_revenue <- beta_0 + beta_1 * advertising_budget + beta_2 * product_price + error_term

# Combine into a clean data frame
business_data <- data.frame(Sales = sales_revenue, 
                            Advertising = advertising_budget, 
                            Price = product_price)

print("--- First 6 rows of the original simulated data ---")
head(business_data)

# ---------------------------------------------------------
# 1.25. Exploratory Data Analysis (EDA) & Descriptive Statistics
# ---------------------------------------------------------
print("--- Summary Statistics ---")
summary(business_data)

print(paste("Sales Variance:", round(var(business_data$Sales), 2)))
print(paste("Sales Standard Deviation:", round(sd(business_data$Sales), 2)))
print(paste("Average (Mean) Sales:", round(mean(business_data$Sales), 2)))

# Generate EDA Plots to check distribution
par(mfrow = c(1, 2)) # Side-by-side plots
boxplot(business_data$Sales, main = "Boxplot of Sales", col = "orange", ylab = "Sales")
plot(density(business_data$Sales), main = "Density Plot of Sales", col = "blue", lwd = 2)
par(mfrow = c(1, 1)) # Reset layout

# ---------------------------------------------------------
# 1.5. Check Linear Regression Assumptions on Base Data
# ---------------------------------------------------------
# Fit a standard Ordinary Least Squares (OLS) model first
base_model <- lm(Sales ~ Advertising + Price, data = business_data)

print("--- Base OLS Model Summary ---")
summary(base_model)

# Generate diagnostic plots to check assumptions
# 1. Residuals vs Fitted (checks Linearity and Homoscedasticity)
# 2. Normal Q-Q (checks Normality of residuals)
par(mfrow = c(2, 2)) # Arrange plots in a 2x2 grid
plot(base_model)
par(mfrow = c(1, 1)) # Reset plot layout

# ---------------------------------------------------------
# 2. Define the Bootstrap Function 
# ---------------------------------------------------------
boot_reg <- function(data, indices) {
  resampled_data <- data[indices, ] 
  fit <- lm(Sales ~ Advertising + Price, data = resampled_data) 
  return(coef(fit)) 
}

# ---------------------------------------------------------
# 3. Perform Bootstrap Simulation
# ---------------------------------------------------------
num_replicates <- 10000
print("Running Bootstrap Simulation (generating 10,000 datasets)... Please wait.")
boot_results <- boot(data = business_data, statistic = boot_reg, R = num_replicates)

# ---------------------------------------------------------
# 4. Results and Confidence Intervals
# ---------------------------------------------------------
print("--- Bootstrap Simulation Results ---")
print(boot_results)

print("--- 95% Confidence Interval: Intercept ---")
boot.ci(boot_results, type = "perc", index = 1)
print("--- 95% Confidence Interval: Advertising Budget ---")
boot.ci(boot_results, type = "perc", index = 2)
print("--- 95% Confidence Interval: Product Price ---")
boot.ci(boot_results, type = "perc", index = 3)

# ---------------------------------------------------------
# 5. Visualizations for the Report
# ---------------------------------------------------------
# A. Fitted Line Plots (Scatter plots with Linear Regression Line)
p_fit_ad <- ggplot(business_data, aes(x = Advertising, y = Sales)) +
  geom_point(color = "darkblue", size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", fill = "pink", se = TRUE) +
  labs(title = "Fitted Linear Model: Sales vs Advertising",
       x = "Advertising Budget (in $1000s)",
       y = "Monthly Sales Revenue") +
  theme_minimal()

p_fit_price <- ggplot(business_data, aes(x = Price, y = Sales)) +
  geom_point(color = "darkgreen", size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", fill = "pink", se = TRUE) +
  labs(title = "Fitted Linear Model: Sales vs Product Price",
       x = "Product Price (in $)",
       y = "Monthly Sales Revenue") +
  theme_minimal()

print(p_fit_ad)
print(p_fit_price)

# B. Bootstrap Coefficient Distribution Plots
boot_df <- data.frame(boot_results$t)
colnames(boot_df) <- c("Intercept", "Advertising_Coef", "Price_Coef")

p_boot_ad <- ggplot(boot_df, aes(x = Advertising_Coef)) +
  geom_histogram(bins = 50, fill = "#2E86C1", color = "black", alpha = 0.8) +
  geom_vline(aes(xintercept = mean(Advertising_Coef)), color = "red", linetype = "dashed", size = 1.2) +
  labs(title = "Bootstrap Distribution: Effect of Advertising on Sales",
       x = "Advertising Coefficient", y = "Frequency") +
  theme_minimal()

p_boot_price <- ggplot(boot_df, aes(x = Price_Coef)) +
  geom_histogram(bins = 50, fill = "#E74C3C", color = "black", alpha = 0.8) +
  geom_vline(aes(xintercept = mean(Price_Coef)), color = "black", linetype = "dashed", size = 1.2) +
  labs(title = "Bootstrap Distribution: Effect of Price on Sales",
       x = "Price Coefficient", y = "Frequency") +
  theme_minimal()

print(p_boot_ad)
print(p_boot_price)

# Save plots for README
ggsave("fitted_ad.png", plot = p_fit_ad, width = 6, height = 4, dpi = 300)
ggsave("fitted_price.png", plot = p_fit_price, width = 6, height = 4, dpi = 300)
ggsave("boot_ad.png", plot = p_boot_ad, width = 6, height = 4, dpi = 300)
ggsave("boot_price.png", plot = p_boot_price, width = 6, height = 4, dpi = 300)
