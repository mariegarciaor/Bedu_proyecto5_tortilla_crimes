# PACKAGES
library(ggplot2)
library(dplyr)
library(DescTools)

load_data <- function() {
  df <- read.csv("mexico_crime_and_tortilla.csv")

# DATA CLEANNING
months_str <- month.name
df$month_num <- match(df$month, months_str)
df$full_date <- as.Date(paste(df$year, df$month_num, "01", sep = "-"))
print(df)

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
View(df_tortilla)

df_crimes <- subset(df, metric == 'crimes')
head(df_crimes, n = 6)
summary(df_crimes)
View(df_crimes)


# BASIC STATISTICS
# Tortilla
# Mean for all store types
mean_tortilla <- mean(df_tortilla$tortilla_price)
print(mean_tortilla)

# Mean for 'Mom and Pop Store'
mean_mom_and_pop <- mean(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, na.rm = TRUE)
print(mean_mom_and_pop)

# Mean for 'Big Retail Store'
mean_big_retail <- mean(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, na.rm = TRUE)
print(mean_big_retail)

# Median
median_tortilla <- median(df_tortilla$tortilla_price)
print(median_tortilla)

# Standard deviation
sd_tortilla <- sd(df_tortilla$tortilla_price)
print(sd_tortilla)

# Standard deviation 'Mom and Pop Store'
sd_mom_and_pop <- sd(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price)
print(sd_mom_and_pop)

# Standard deviation 'Big Retail Store'
sd_big_retail <- sd(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price)
print(sd_big_retail)

# These results indicate that tortilla prices have different variability depending on the type of store, with the lowest variability in 'Big Retail Store' types compared to 'Mom and Pop Store' types.

# Minimum
minimum_tortilla <- min(df_tortilla$tortilla_price)
print(minimum_tortilla)

# Minimum 'Mom and Pop Store'
minimum_mom_and_pop <- min(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price)
print(minimum_mom_and_pop)

# Minimum for 'Big Retail Store'
minimum_big_retail <- min(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price)
print(minimum_big_retail)


# Maximum
maximum_tortilla <- max(df_tortilla$tortilla_price)
print(maximum_tortilla)

# Maximum for 'Mom and Pop Store'
maximum_mom_and_pop <- max(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price)
print(maximum_mom_and_pop)

# Maximum for 'Big Retail Store'
maximum_big_retail <- max(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price)
print(maximum_big_retail)


# Quantiles
quantile(df_tortilla$tortilla_price, c(0.25,0.50,0.75))
quantile(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price, c(0.25, 0.50, 0.75))
quantile(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price, c(0.25, 0.50, 0.75))

IQR(df_tortilla$tortilla_price)
IQR(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price)
IQR(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price)
# Analysis: The IQR is a measure of dispersion that indicates the spread of central values in a dataset. It is the difference between the third quartile (Q3) and the first quartile (Q1), that is, IQR = Q3 - Q1.
# Tortilla prices at 'Big Retail Store' types of stores have a narrower dispersion compared to 'Mom and Pop Store' types and overall across the entire dataset.


var(df_tortilla$tortilla_price)
var(filter(df_tortilla, store_type == 'Mom and Pop Store')$tortilla_price)
var(filter(df_tortilla, store_type == 'Big Retail Store')$tortilla_price)
# Analysis: Variance provides information about the dispersion of tortilla prices around the mean.
# Tortilla prices at 'Big Retail Store' types of stores are more clustered around a central value.


# mexico_crimes
mean_crimes <- mean(df_crimes$count_of_crimes)
print(mean_crimes)

median_crimes <- median(df_crimes$count_of_crimes)
print(median_crimes)

sd_crimes <- sd(df_crimes$count_of_crimes)
print(sd_crimes)

minimum_crimes <- min(df_crimes$count_of_crimes)
print(minimum_crimes)

maximum_crimes <- max(df_crimes$count_of_crimes)
print(maximum_crimes)


# SIMPLIFIED SUBSETS
# We created simplified subsets that allowed us to have only one aggregated row per state and date (month, year).
tortilla_simp_df <- df_tortilla %>%
  filter(store_type == 'Mom and Pop Store') %>%
  group_by(state, full_date, year, month) %>%
  summarise(tortilla_avg_price = mean(tortilla_price)) %>%
  arrange(state, full_date)
print(tortilla_simp_df)

crime_simp_df <- df_crimes %>%
  group_by(state, full_date) %>%
  summarise(total_crimes = sum(count_of_crimes)) %>%
  arrange(state, full_date)
print(crime_simp_df)

# FINAL DATASET (MERGED)
full_df <- merge(tortilla_simp_df, crime_simp_df, by = c("full_date", "state"))
View(full_df)

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


full_df %>% sample_n(6)

# Correlation
# For whole dataset
correlation_total <- cor(full_df$tortilla_avg_price, full_df$total_crimes, use = "complete.obs")
print(paste("Total Correlation:", correlation_total))

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

print(paste("Total Correlation:", correlation_total))
View(correlation_by_state)


# Crear un gráfico de barras para la correlación por estado
bar_plot <- ggplot(correlation_by_state, aes(x = state, y = correlation, fill = correlation_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Correlation by State",
       x = "State",
       y = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Mostrar el gráfico de barras
print(bar_plot)

# Return a list of objects
data_list <- list(
  df = df,
  df_tortilla = df_tortilla,
  df_crimes = df_crimes,
  mean_tortilla = mean_tortilla,
  mean_mom_and_pop = mean_mom_and_pop,
  mean_big_retail = mean_big_retail,
  tortilla_simp_df = tortilla_simp_df,
  crime_simp_df = crime_simp_df,
  full_df = full_df,
  correlation_total = correlation_total,
  correlation_by_state = correlation_by_state,
  bar_plot = bar_plot
)

return(data_list)

}