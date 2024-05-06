library(class)
library(dplyr)
library(stringr)

library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)

shinyUI(
  pageWithSidebar(
    headerPanel("Proyecto 5"),
    sidebarPanel(
      p("Personaliza tu gráfico"), 
      selectInput("x", "Selecciona la variable",
                  choices = colnames(tortilla_prices))
    ),
    mainPanel(
      h1("Análisis precio de la tortilla"),
      p("En este análisis se utilizarán datos recopilados de más de 270,000 registros de precios de tortilla, abarcando diversas ciudades y establecimientos en todo el país."),
      
      # Agregando pestañas
      tabsetPanel(
        tabPanel("Gráfico", plotOutput("output_plot")),
        tabPanel("Imágenes",img( src = "precio_tortilla.png",height = 700, width = 450)),
        tabPanel("Summary", verbatimTextOutput("output_summary")),
        tabPanel("Tabla", tableOutput("output_table")),
        tabPanel("DataTable", DTOutput("output_data_table"))
      )
    )
  )
)
