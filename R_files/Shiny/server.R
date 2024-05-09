library(shiny)
library(ggplot2)
library(dplyr)  # Necesario para el filtrado de datos

shinyServer(function(input, output) {
  
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
                          "month" = {
                            if (length(input$selected_months) == 0) {
                              full_df
                            } else {
                              filter(full_df, month %in% input$selected_months)
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
    
    if (length(input$selected_states) == 0) {
      # Si no se ha seleccionado ningún estado, se muestran todos los estados por defecto
      filtered_df <- full_df
    } else {
      # Si se han seleccionado estados específicos, se filtra el dataframe por esos estados
      filtered_df <- filter(filtered_df, state %in% input$selected_states)
    }
    
    # Generar el gráfico
    ggplot(filtered_df, aes_string(x = input$x, y = input$y, color = "state")) +
      geom_line() +
      labs(title = paste(input$y, "Over", input$x),
           x = input$x, y = input$y,
           color = "State")
  })
  
  # Summary
  output$output_summary <- renderPrint({
    summary(full_df)
  })
  
  # Tabla
  output$output_table <- renderTable({
    data.frame(full_df)
  })
  
  # DataTable
  output$output_data_table <- renderDataTable({
    full_df
  }, options = list(aLengthMenu = c(5, 25, 50),
                    iDisplayLength = 5))
})