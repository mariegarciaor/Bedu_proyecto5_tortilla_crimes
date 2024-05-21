library(shiny)
library(ggplot2)
library(dplyr)
library(DT)



ui <- fluidPage(
    tags$head(
      tags$style(HTML("
        .tab-content {
          margin-top: 20px; /* Márgen arriba del tabsetPanel */
        }
        .tab-pane {
          padding: 10px; /* Espaciado dentro de cada pestaña */
        }
        .sidebar-panel-content {
          margin: 10px; /* Márgenes alrededor del contenido del sidebarPanel */
        }
        body {
          margin: 20px; /* Márgenes alrededor del contenido de la página */
        }
      "))
    ),
    h2("Análisis del vínculo entre el crimen y el precio de la tortilla en México"),
    h5("En este análisis se utilizarán datos recopilados de más de 270,000 registros de precios de tortilla, abarcando diversas ciudades y establecimientos en todo el país."),
    tabsetPanel(
      
      #intro
      tabPanel("Introducción", uiOutput("introduccion_content")),
      #plots
      tabPanel("Timeline",
               sidebarPanel(
                 h5("Personaliza tu gráfico"), 
                 selectInput("y", "Selecciona la metrica:",
                             choices = list("Precio promedio de tortilla" = "tortilla_avg_price",
                                            "Total de crímenes" = "total_crimes")),
                 selectInput("selected_states",
                             "Selecciona los estados a mostrar:",
                             choices = unique(full_df$state),
                             multiple = TRUE),
                 selectInput("x", "Selecciona el tipo de periodo:",
                             choices = list("Fecha completa" = "full_date", "Año" = "year")),
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
                 plotOutput("my_plot")
               )
      ),
      # Correlations
      tabPanel("Correlations",
               sidebarPanel(
                 h5("Filtros de Correlación"),
                 selectInput("selected_states_correlation",
                             "Selecciona los estados:",
                             choices = unique(correlation_by_state$state),
                             multiple = TRUE),
                 selectInput("selected_correlation_type",
                             "Selecciona el tipo de correlación:",
                             choices = unique(correlation_by_state$correlation_type),
                             multiple = TRUE)
               ),
               mainPanel(
                 # Organizar elementos verticalmente
                 column(width = 12,
                        # Parte superior con el gráfico de barras
                        plotOutput("bar_plot", height = 400)),
                 column(width = 12,
                        # Parte inferior con la tabla de correlación
                        dataTableOutput("correlation_table"))
               )
      ),
      
      #DataTable
      tabPanel("Datatables",
               # DataTable
               h5("Tabla principal"),
               DTOutput("output_data_table"),
               # Tabla - detalles de precios de tortillas
               h5("Tabla de precios de tortillas"),
               DTOutput("output_table_tortilla"),
               # Tabla - detalles de crímenes
               h5("Tabla de crímenes"),
               DTOutput("output_table_crimes")
      ),
      # Summary 
      tabPanel("Summary", verbatimTextOutput("output_summary")),
      tabPanel("Conclusiones", htmlOutput("rhtml_content"))
  )
)