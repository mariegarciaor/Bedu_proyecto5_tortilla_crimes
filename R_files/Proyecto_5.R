#Datasets imports
crime <- read.csv("mexico_crime.csv")
tortilla <- read.csv("tortilla_prices.csv")


# Samples
sample_crime <- sample(crime, size = 5, replace = FALSE)
head(sample_crime)
sample_tortilla <- sample(tortilla, size = 5, replace = FALSE)
head(sample_tortilla)


# Standarize column names to lowercase
colnames(tortilla) <- tolower(colnames(tortilla))
colnames(crime) <- tolower(colnames(crime))


# Column names
colnames(crime)
# "year", "entity_code", "entity", "affected_legal_good", "type_of_crime", "subtype_of_crime", "modality", "month", "count"
colnames(tortilla)
#"state", "city", "year", "month", "day", "store.type", "price.per.kilogram"


# Data subsets - to standardize date range (2015 al 2023)
mexico_crime <- subset(crime, year >= 2015 & year <= 2023)
tortilla_prices <- subset(tortilla, year >= 2015 & year <= 2023)

# State/entity cleanup
# mexico_crime
mexico_crime$entity <- gsub("Ciudad de México", "CDMX", mexico_crime$entity)
mexico_crime$entity <- gsub("Michoacán de Ocampo", "Michoacan", mexico_crime$entity)
mexico_crime$entity <- gsub("Veracruz de Ignacio de la Llave", "Veracruz", mexico_crime$entity)
mexico_crime$entity <- gsub("Coahuila de Zaragoza", "Coahuila", mexico_crime$entity)
mexico_crime$entity <- gsub("México", "Estado de Mexico", mexico_crime$entity)
mexico_crime$entity <- gsub("Querétaro", "Queretaro", mexico_crime$entity)
mexico_crime$entity <- gsub("Nuevo León", "Nuevo Leon", mexico_crime$entity)
mexico_crime$entity <- gsub("Yucatán", "Yucatan", mexico_crime$entity)
mexico_crime$entity <- gsub("San Luis Potosí", "San Luis Potosi", mexico_crime$entity)


# tortilla_prices
tortilla_prices$state <- gsub("D.F.", "CDMX", tortilla_prices$state)
tortilla_prices$state <- gsub("Querétaro", "Queretaro", tortilla_prices$state)
tortilla_prices$state <- gsub("Michoacán", "Michoacan", tortilla_prices$state)
tortilla_prices$state <- gsub("Yucatán", "Yucatan", tortilla_prices$state)

#no funcionan
tortilla_prices$state <- gsub("Edo\\.\\sMexico","Estado de Mexico", tortilla_prices$state)
tortilla_prices$state <- gsub("Nuevo\\sLeón", "Nuevo Leon", tortilla_prices$state)
tortilla_prices$state <- gsub("San\\sLuis\\sPotosí", "San Luis Potosi", tortilla_prices$state)

# Verificar los valores únicos en la columna state de tortilla_prices para asegurarnos de la escritura exacta
unique(mexico_crime$entity)
num_unique_values <- length(unique(mexico_crime$entity))
num_unique_values

unique(tortilla_prices$state)
num_unique_values <- length(unique(tortilla_prices$state))
num_unique_values


