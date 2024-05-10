library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Cargar datos al iniciar la aplicación
source("functions.R")
data <- load_data()
df_tortilla <- data$df_tortilla
df_crimes <- data$df_crimes
full_df <- data$full_df
correlation_by_state <- data$correlation_by_state
mean_tortilla <- data$mean_tortilla
mean_mom_and_pop<- data$mean_mom_and_pop
mean_big_retail<- data$mean_big_retail
tortilla_simp_df<- data$tortilla_simp_df
crime_simp_df<- data$crime_simp_df
correlation_total<- data$correlation_total
correlation_by_state<- data$correlation_by_state
bar_plot<- data$bar_plot

# Se define el servidor para la aplicación Shiny
shinyServer(
function(input, output) {
  
  # Plots
  output$my_plot <- renderPlot({
    # Filtrar los datos según la variable x seleccionada y el modo de visualización
    filtered_df <- switch(input$x,
                          "year" = {
                            if (length(input$selected_years) == 0) {
                              full_df
                            } else {
                              filter(full_df, year %in% input$selected_years)
                            }
                          },
                          "full_date" = {
                            if (length(input$selected_full_dates) == 0) {
                              full_df
                            } else {
                              filter(full_df, full_date %in% input$selected_full_dates)
                            }
                          },
                          full_df)
    # Si no se ha seleccionado ningún estado, se muestran todos los estados por defecto
    if (length(input$selected_states) == 0) {
      filtered_df <- full_df
    } else {
      # Si se han seleccionado estados específicos, se filtra el dataframe por esos estados
      filtered_df <- filter(filtered_df, state %in% input$selected_states)
    }
    
    # Generar el gráfico
    ggplot(filtered_df, aes_string(x = input$x, y = input$y, color = "state", group = "state")) +
      geom_line() +
      labs(title = paste(input$y, "Over", input$x),
           x = input$x, y = input$y,
           color = "State")
  })
  
  # Correlación
  # Mostrar el gráfico de barras
  output$bar_plot <- renderPlot({
    data_list$bar_plot
  })
  
  # Mostrar la tabla
  output$correlation_table <- renderDataTable({
    data_list$correlation_by_state
  })
  
  
  # Summary
  output$output_summary <- renderPrint({
    summary(full_df)
  })
  
  # DataTable
  output$output_data_table <- renderDataTable({
    full_df
  }, options = list(aLengthMenu = c(5, 25, 50),
                    iDisplayLength = 5))
  
  # DataTable Tortilla
  output$output_table_tortilla <- renderDataTable({
    selected_cols <- c("year", "month", "state", "tortilla_price", "store_type")
    df_tortilla_subset <- df_tortilla[, selected_cols, drop = FALSE]
    df_tortilla_subset
  }, options = list(
    searching = TRUE,  # Habilitar búsqueda
    searchCols = c(1, 2, 3, 4, 5, 6), # Habilitar búsqueda por todas las columnas
    ordering = TRUE,   # Habilitar ordenación
    paging = TRUE,     # Habilitar paginación
    aLengthMenu = c(5, 25, 50),  # Longitudes de página personalizadas
    iDisplayLength = 5  # Longitud de página inicial
  ))
  
  # DataTable Crimes
  output$output_table_crimes <- renderDataTable({
    selected_cols <- c("year", "month", "state", "count_of_crimes", "type_of_crime")
    df_crimes_subset <- df_crimes[, selected_cols, drop = FALSE]
    df_crimes_subset
  }, options = list(
    searching = TRUE,  
    searchCols = c(1, 2, 3, 4, 5, 6),
    ordering = TRUE, 
    paging = TRUE,
    aLengthMenu = c(5, 25, 50),
    iDisplayLength = 5
  ))

})