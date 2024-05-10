library(shiny)
library(ggplot2)
library(dplyr)
library(DT)



ui <- fluidPage(
  headerPanel("Proyecto 5"),
  sidebarPanel(
    p("Personaliza tu gráfico"), 
    selectInput("y", "Selecciona la variable y:",
                choices = c("tortilla_avg_price", "total_crimes")),
    selectInput("x", "Selecciona la variable x:",
                choices = c("year", "full_date")),
    selectInput("selected_states",
                "Selecciona los estados a mostrar:",
                choices = unique(full_df$state),
                multiple = TRUE),
    conditionalPanel(
      condition = "input.x == 'year'",
      selectInput("selected_years",
                  "Selecciona los años:",
                  choices = unique(full_df$year),
                  multiple = TRUE)
    ),
    conditionalPanel(
      condition = "input.x == 'full_date'",
      selectInput("selected_full_dates",
                  "Selecciona las fechas:",
                  choices = unique(full_df$full_date),
                  multiple = TRUE)
    ),
    conditionalPanel(
      condition = "input.selected_states == 'state'",
      selectInput("selected_states",
                  "Selecciona los estados:",
                  choices = unique(full_df$state),
                  multiple = TRUE))
  ),
  mainPanel(
    h1("Análisis precio de la tortilla"),
    p("En este análisis se utilizarán datos recopilados de más de 270,000 registros de precios de tortilla, abarcando diversas ciudades y establecimientos en todo el país."),
    tabsetPanel(
      
      #plots
      tabPanel("Plots",
               plotOutput("my_plot")
      ),
      
      # Summary 
      tabPanel("Summary", verbatimTextOutput("output_summary")),
      # Table
      tabPanel("Table", tableOutput("output_table")),
      #DataTable
      tabPanel("DataTable", DTOutput("output_data_table"))
    )
  )
)