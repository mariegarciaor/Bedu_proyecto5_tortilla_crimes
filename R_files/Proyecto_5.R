# Packages
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
install.packages("DescTools")
library(DescTools)

# Datasets imports
df <- read.csv("/cloud/project/databases/mexico_crime_and_tortilla.csv")
print(df)

# Month clean
months_str <- month.name
df$month_num <- match(df$month, months_str)
df$full_date <- as.Date(paste(df$year, df$month_num, "01", sep = "-"))
print(df)

# Structure of dataset
dim(df)
class(df)
str(df)

# Samples of dataset
head(df)
tail (df)
df_sample <- df[sample(nrow(df), 5, replace = FALSE), ]
df_sample


# Subsets
df_tortilla <- subset(df, metric == 'tortilla_prices')
head(df_tortilla, n = 6)
summary(df_tortilla)
View(df_tortilla)

df_crimes <- subset(df, metric == 'crimes')
head(df_crimes, n = 6)
summary(df_crimes)
View(df_crimes)

# Basic statistics
# Mean
mean_tortilla <- mean(df_tortilla$tortilla_price)
print(mean_tortilla)

mean_crimes <- mean(df_crimes$count_of_crimes)
print(mean_crimes)

# Median
median_tortilla <- median(df_tortilla$tortilla_price)
print(median_tortilla)

median_crimes <- median(df_crimes$count_of_crimes)
print(median_crimes)

# Standard deviation
sd_tortilla <- sd(df_tortilla$tortilla_price)
print(sd_tortilla)

sd_crimes <- sd(df_crimes$count_of_crimes)
print(sd_crimes)

# Minimum
minimum_tortilla <- min(df_tortilla$tortilla_price)
print(minimum_tortilla)

minimum_crimes <- min(df_crimes$count_of_crimes)
print(minimum_crimes)

# Maximum
maximum_tortilla <- max(df_tortilla$tortilla_price)
print(maximum_tortilla)

maximum_crimes <- max(df_crimes$count_of_crimes)
print(maximum_crimes)

# Quantiles
quantile(df_tortilla$tortilla_price, c(0.25,0.50,0.75))
IQR(df_tortilla$tortilla_price)
var(df_tortilla$tortilla_price)


# Simplified subsets
# We created simplified subsets that allowed us to have only one aggregated row per state and date (month, year).
tortilla_simp_df <- df_tortilla %>%
  group_by(metric, state, full_date) %>%
  summarise(tortilla_avg_price = mean(tortilla_price)) %>%
  arrange(state, full_date)
print(tortilla_simp_df)

crime_simp_df <- df_crimes %>%
  group_by(metric, state, full_date) %>%
  summarise(total_crimes = sum(count_of_crimes)) %>%
  arrange(state, full_date)
print(crime_simp_df)

# Merged dataset
full_df <- merge(tortilla_simp_df, crime_simp_df, by = c("full_date", "state"))
print(full_df)
View(full_df)
