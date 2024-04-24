install.packages("DBI")
install.packages("RMySQL")
install.packages("dplyr")

library(DBI)
library(RMySQL)
library(dplyr)


#creación de una conexión a una bd
base <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest"
)

dbListTables(base)
dbListFields(base, "City")

?dbGetQuery
df <- dbGetQuery(base,"Select * from City where Population > 5000")
class(df) #function
typeof(df) #closure

mean(df$Population)

df %>% filter( CountryCode == 'MEX') %>% head(5)

#Reto 1
dbListFields(base, "CountryLanguage")
df <- dbGetQuery(base,"Select * from CountryLanguage")
df %>% filter( Language == 'Spanish') %>% head(5)


#ejemplo 2
install.packages("pool")
install.packages("dbplyr")

library(pool)
library(dbplyr)

db_pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest"
)
dbListTables(db_pool)

db_pool %>% tbl("CountryLanguage") %>% head(5)

db_3 <- dbConnect(
  RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest"
)

rs <- dbSendQuery(db_3,)

#Ejemplo
install.packages("rjson")
library(rjson)

json <- fromJSON(file = "json_ejemplo4.json")
json

#Reto 2
install.packages("rvest")
library(rvest)

url <- "https://www.glassdoor.com.mx/Sueldos/data-scientist-sueldo-SRCH_KO0,14.htm"

file<-read_html(url)
