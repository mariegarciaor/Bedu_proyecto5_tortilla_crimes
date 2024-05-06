library(shiny)
library(DT)

shinyServer(
  function(input, output) {
    
    # Texto
    output$output_text <- renderText({
      paste("Gráfico de", input$x)
    })
    
    # Gráfico
    output$output_plot <- renderPlot({
      barplot(table(tortilla_prices[[input$x]]), 
              main = paste("Frecuencia de", input$x, "por estado"), 
              xlab = "Estado", ylab = "Frecuencia")
    })
    
    # Summary
    output$output_summary <- renderPrint({
      summary(tortilla_prices)
    })
    
    # Tabla
    output$output_table <- renderTable({
      data.frame(tortilla_prices)
    })
    
    # DataTable
    output$output_data_table <- renderDataTable({tortilla_prices}, 
                                         options = list(aLengthMenu = c(5,25,50),
                                                        iDisplayLength = 5))
    })

