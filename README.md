# Business Analytics: Regression Modeling with Bootstrap Simulation

This project demonstrates how to leverage **Bootstrap Simulation** combined with Multiple Linear Regression to derive highly reliable business insights. We predict **Monthly Sales Revenue** based on two key drivers: **Advertising Budget** and **Product Price**.

## 🎯 The Core Point: Why Use Bootstrap in Business Analysis?

In standard business analytics, we often rely on Ordinary Least Squares (OLS) regression to understand how factors like ad spend or pricing affect sales. However, standard regression relies on strict mathematical assumptions (perfect normality, constant variance, no severe outliers). In the real world, especially with small datasets (like our n = 50 companies), these assumptions are rarely met perfectly.

**The Solution:** Instead of trusting a single model run, we use **Bootstrap Resampling**. We simulate taking 10,000 different samples from our original data and run 10,000 regression models. 

### How It Helps Business Analysis:
1. **Robustness Without Strict Assumptions:** It provides accurate confidence intervals without requiring perfectly normal data.
2. **Reliable Risk Bounds:** Decision-makers don't just want a single "average" estimate; they want to know the "worst-case" and "best-case" ROI. Bootstrap mathematically bounds this risk.
3. **Data-Driven Confidence:** It proves the stability of our findings, which is critical when allocating millions of dollars in advertising or setting competitive pricing.

### Scenarios Where Bootstrapping is Essential:
- **Small Sample Sizes:** When evaluating a pilot program across only 30-50 stores.
- **Financial Risk Modeling:** When standard error estimates must be extremely accurate to avoid financial loss.
- **Non-Normal Data:** When dealing with skewed data (e.g., customer lifetime value) where standard models fail.

---

## 📊 Results & Interpretation

Our base dataset contains 50 records. Initial descriptive statistics show:
- **Average Monthly Sales:** $666.48
- **Sales Standard Deviation:** $153.80

### 1. The Effect of Advertising (Positive Driver)
*For every additional $1,000 spent on advertising, how much do sales increase?*

![Fitted Advertising Model](fitted_ad.png)
![Bootstrap Distribution: Advertising](boot_ad.png)

**Interpretation:**
The standard model estimated a ~$4.98 return. After running 10,000 bootstrap simulations, our **95% Confidence Interval is (4.618, 5.325)**. 
**Business Insight:** We can tell stakeholders with 95% certainty that every additional $1,000 invested in advertising will consistently generate between **$4,618** and **$5,325** in new monthly sales. This proves advertising is a highly stable and profitable investment.

### 2. The Effect of Product Price (Negative Driver)
*How much do sales drop when we increase our product price by $1?*

![Fitted Price Model](fitted_price.png)
![Bootstrap Distribution: Price](boot_price.png)

**Interpretation:**
Our bootstrap simulation generated a **95% Confidence Interval of (-2.136, -1.596)** for the price coefficient.
**Business Insight:** Increasing the product price by $1 will reliably decrease overall monthly sales volume by between **$1,596** and **$2,136**. This allows the pricing strategy team to calculate the exact price elasticity and determine if a price hike is worth the associated volume loss.

---

## 🛠️ Project Maintenance & Execution

The analysis code is fully functional. To reproduce these results:
1. Ensure `R` is installed with the `ggplot2` and `boot` packages.
2. Run the script: `Rscript bootstrap_regression.R`
3. Check the console output for exact confidence intervals and view the generated `.png` plots for the distributions.
