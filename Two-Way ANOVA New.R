# TWO-WAY ANOVA WITH INTERACTION

## **LOAD LIBRARIES**

```{r}
# For everything that is good in R
library(tidyverse)

# To get useful summary statistics
library(summarytools)

# To run the Brown-Forsythe test to check homogeneity of variances
library(lawstat)

# To visualize data
library(ggpubr)

# To compute estimated marginal means
library(emmeans)

# To write automated statistical reports
library(report)
```

## **ATTACH DATA**

```{r}
# Store the Tooth Growth dataset
df <- datasets::ToothGrowth

# Get the structure of the dataset
str(df)

# Convert `dose` which has been recognized as numeric to a factor
df$dose <- as.factor(df$dose)

# Attach the dataframe to enable easy calling of variables
attach(df)

# Get the first 6 rows of the dataframe
head(df)

# Get the last 6 rows of the dataframe
tail(df)

# Get more information for the dataset
?ToothGrowth
```

## **SUMMARY STATISTICS**

```{r}
# Use the `dfSummary` function 
sum1 <- df[supp=="VC",] %>% group_by(dose) %>% dfSummary()
sum2 <- df[supp=="OJ",] %>% group_by(dose) %>% dfSummary()
```

## VISUAL DATA EXPLORATION

```{r}
# Get boxplots for tooth length grouped by `dose` and separate plots for `supp`
ggplot(df) + geom_boxplot(aes(x = dose, y = len, fill = supp)) + facet_grid(rows = supp)

# Get boxplots for tooth length grouped by both `dose` and `supp`
ggplot(df) + geom_boxplot(aes(x = dose, y = len, fill = supp))
```

## **ANOVA ASSUMPTIONS**

1.  Dependent variable is continuous.

2.  Independent variables are factors with 2 or more levels.

3.  Independence: The observations in each group are independent of each other.

4.  The observations are random samples of the population.

5.  Normality: Each sample was drawn from a normally distributed population.

    ```{r}
    # Runs the Shapiro-Wilk test for normality
    shapiro.test(len[dose==0.5 & supp=="VC"])
    shapiro.test(len[dose==1 & supp=="VC"])
    shapiro.test(len[dose==2 & supp=="VC"])
    shapiro.test(len[dose==0.5 & supp=="OJ"])
    shapiro.test(len[dose==1 & supp=="OJ"])
    shapiro.test(len[dose==2 & supp=="OJ"])
    ```

6.  Homogeneity of variances: The variances of the populations that the samples come from are equal.

    ```{r}
    # Runs the Brown-Forsythe test for homogeneity of variances
    levene.test(len[supp=="VC"], dose[supp=="VC"])
    levene.test(len[supp=="OJ"], dose[supp=="OJ"])
    ```

## **TWO-WAY ANALYSIS OF VARIANCE WITH INTERACTION**

```{r}
# Run our two-way analysis of variance without an interaction term and store results in `fit1` 
fit <- aov(len ~ dose + supp + dose*supp)

# Automate statistical reporting of the ANOVA 
report(fit)
```

## ESTIMATED MARGINAL MEANS

```{r}
# Compute and store the estimated marginal means in an object 
em <- emmeans(fit, pairwise ~ dose*supp)

# Get results for the estimated marginal means 
summary(em)

# Get confidence intervals for the estimated marginal means 
confint(em)

# Plot the estimated marginal means 
plot(em, horizontal=F)
```
