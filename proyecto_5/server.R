library(shiny)

shinyServer(
  function(input, output) {
    
    # vamos a tener dos salidas, texto y plot
    # input$x es el input que recibe la app
    output$output_text <- renderText(paste("Gráfico de", input$x, "~ state"))
    
    output$output_plot <- renderPlot({
      barplot(table(tortilla_prices[[input$x]]), 
              main = paste("Frecuencia de", input$x, "por estado"), 
              xlab = "Estado", ylab = "Frecuencia")
    })
    
  }
)
