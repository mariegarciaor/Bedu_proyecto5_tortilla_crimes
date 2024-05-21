library(ggplot2)
library(dplyr)
library(DescTools)

df <- read.csv("mexico_crime_and_tortilla.csv")
df

# DATA CLEANNING
months_str <- month.name
df$month_num <- match(df$month, months_str)
df$full_date <- as.Date(paste(df$year, df$month_num, "01", sep = "-"))


# DATASET STRUCTURE ANALYSIS
dim(df)
class(df)
str(df)


# SAMPLES
head(df)
tail (df)
df_sample <- df[sample(nrow(df), 5, replace = FALSE), ]
df_sample


# SUBSETS
df_tortilla <- subset(df, metric == 'tortilla_prices')
head(df_tortilla, n = 6)
summary(df_tortilla)

df_crimes <- subset(df, metric == 'crimes')
head(df_crimes, n = 6)
summary(df_crimes)


# BASIC STATISTICS
# Tortilla - All Store Types
mean_tortilla <- mean(df_tortilla$tortilla_price, na.rm = TRUE)
median_tortilla <- median(df_tortilla$tortilla_price, na.rm = TRUE)
sd_tortilla <- sd(df_tortilla$tortilla_price, na.rm = TRUE)
minimum_tortilla <- min(df_tortilla$tortilla_price, na.rm = TRUE)
maximum_tortilla <- max(df_tortilla$tortilla_price, na.rm = TRUE)
quantile_tortilla <- quantile(df_tortilla$tortilla_price, c(0.25, 0.50, 0.75), na.rm = TRUE)
iqr_tortilla <- IQR(df_tortilla$tortilla_price, na.rm = TRUE)
var_tortilla <- var(df_tortilla$tortilla_price, na.rm = TRUE)

# Tortilla - 'Mom and Pop Store'
mean_mom_and_pop <- mean(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
sd_mom_and_pop <- sd(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
minimum_mom_and_pop <- min(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
maximum_mom_and_pop <- max(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
quantile_mom_and_pop <- quantile(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, c(0.25, 0.50, 0.75), na.rm = TRUE)
iqr_mom_and_pop <- IQR(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
var_mom_and_pop <- var(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)

# Tortilla - 'Big Retail Store'
mean_big_retail <- mean(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
sd_big_retail <- sd(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
minimum_big_retail <- min(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
maximum_big_retail <- max(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
quantile_big_retail <- quantile(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, c(0.25, 0.50, 0.75), na.rm = TRUE)
iqr_big_retail <- IQR(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
var_big_retail <- var(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)

# Analysis: 
# These results indicate that tortilla prices have different variability depending on the type of store, with the lowest variability in 'Big Retail Store' types compared to 'Mom and Pop Store' types.
# The IQR is a measure of dispersion that indicates the spread of central values in a dataset. 
# Variance provides information about the dispersion of tortilla prices around the mean.
# Tortilla prices at 'Big Retail Store' types of stores are more clustered around a central value.

# mexico_crimes
mean_crimes <- mean(df_crimes$count_of_crimes, na.rm = TRUE)
median_crimes <- median(df_crimes$count_of_crimes, na.rm = TRUE)
sd_crimes <- sd(df_crimes$count_of_crimes, na.rm = TRUE)
minimum_crimes <- min(df_crimes$count_of_crimes, na.rm = TRUE)
maximum_crimes <- max(df_crimes$count_of_crimes, na.rm = TRUE)
df_tortilla

# SIMPLIFIED SUBSETS
# We created simplified subsets that allowed us to have only one aggregated row per state and date (month, year).
tortilla_simp_df <- df_tortilla %>%
  filter(store_type == 'Mom and Pop Store') %>%
  group_by(state, full_date, year, month) %>%
  summarise(tortilla_avg_price = mean(tortilla_price, na.rm = TRUE)) %>%
  arrange(state, full_date)
print(tortilla_simp_df)

crime_simp_df <- df_crimes %>%
  group_by(state, full_date) %>%
  summarise(total_crimes = sum(count_of_crimes, na.rm = TRUE)) %>%
  arrange(state, full_date)
print(crime_simp_df)

# FINAL DATASET (MERGED)
full_df <- merge(tortilla_simp_df, crime_simp_df, by = c("full_date", "state"))


# ANALYSIS
# Analyzing Tortilla Price Change Rates
# Below and Above Average Trend by Year
avg_prices_by_year <- full_df %>%
  group_by(year) %>%
  summarise(yly_tortilla_avg_price = mean(tortilla_avg_price, na.rm = TRUE))

full_df <- full_df %>%
  left_join(avg_prices_by_year, by = "year") %>%
  mutate(price_vs_avg_year = ifelse(tortilla_avg_price > yly_tortilla_avg_price, "Above Year Average", "Below Year Average"))

# Tortilla Price Change Rates Over Time by State
full_df <- full_df %>%
  arrange(state, full_date) %>%
  group_by(state) %>%
  mutate(price_change_rate = (tortilla_avg_price - lag(tortilla_avg_price)) / lag(tortilla_avg_price))


# Analyzing Crime Change Rates
# Below and Above Average Trend by Year
avg_crimes_by_year <- full_df %>%
  group_by(year) %>%
  summarise(yly_avg_crimes = mean(total_crimes, na.rm = TRUE))

full_df <- full_df %>%
  left_join(avg_crimes_by_year, by = "year") %>%
  mutate(crimes_vs_avg_year = ifelse(total_crimes > yly_avg_crimes, "Above Year Average", "Below Year Average"))

# Crimes Change Rates Over Time by State
full_df <- full_df %>%
  arrange(state, full_date) %>%
  group_by(state) %>%
  mutate(crimes_change_rate = (total_crimes - lag(total_crimes)) / lag(total_crimes))

sample_n(full_df, 6)

# Correlation
# For whole dataset
correlation_total <- cor(full_df$tortilla_avg_price, full_df$total_crimes, use = "complete.obs")

# by State
correlation_by_state <- full_df %>%
  group_by(state) %>%
  summarise(correlation = cor(tortilla_avg_price, total_crimes, use = "complete.obs"))

# Categorization 
correlation_by_state <- correlation_by_state %>%
  mutate(correlation_type = case_when(
    correlation > 0.7 ~ "Strong Positive Correlation",
    correlation > 0 & correlation <= 0.7 ~ "Weak Positive Correlation",
    correlation < -0.7 ~ "Strong Negative Correlation",
    correlation >= -0.7 & correlation < 0 ~ "Weak Negative Correlation",
    abs(correlation) <= 0.7 ~ "Weak Correlation"
  ))

View(correlation_by_state)
write.csv(correlation_by_state, "correlation_by_state.csv", row.names = FALSE)
