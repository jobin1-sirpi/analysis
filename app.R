# Simple Shiny application that will work on Posit Connect Cloud
library(shiny)

ui <- fluidPage(
  titlePanel("Wind Shear Analysis Tool"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("height", "Target Height (m):", value = 100, min = 10, max = 250),
      actionButton("analyze", "Run Analysis", class = "btn-primary")
    ),
    
    mainPanel(
      verbatimTextOutput("info"),
      textOutput("result")
    )
  )
)

server <- function(input, output, session) {
  output$info <- renderPrint({
    # Print R session info to see what's available
    sessionInfo()
  })
  
  output$result <- renderText({
    if(input$analyze > 0) {
      paste("Analysis would run for height:", input$height, "m")
    }
  })
}

shinyApp(ui = ui, server = server)
