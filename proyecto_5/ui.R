library(shiny)

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
      
      #Agregando pestañ±as
      tabsetPanel(
        tabPanel("Gráfica",
                 h3(textOutput("output_text")), 
                 plotOutput("output_plot"), 
        ),
        
        tabPanel("imágenes",
                 img( src = "precio_tortilla.png", 
                      height = 700, width = 450)
        ), 
        
        tabPanel("Summary", verbatimTextOutput("summary")),     # <--------- Summary
        tabPanel("Table", tableOutput("table")),                # <--------- Table
        tabPanel("Data Table", dataTableOutput("data_table"))   # <--------- Data table
      )
      
    )
  )
)



