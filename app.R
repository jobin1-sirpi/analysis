# Wind Shear Analysis Shiny Application
library(shiny)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(openxlsx)
source("R/functions.R")  # Load supporting functions

# UI Definition
ui <- fluidPage(
  titlePanel("Wind Shear Analysis Tool"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("height", "Target Height (m):", value = 100, min = 10, max = 250),
      checkboxInput("drop_na", "Remove NA values", value = TRUE),
      sliderInput("alpha", "Alpha Range:", min = 0.1, max = 1.0, value = c(0.1, 0.7)),
      sliderInput("z0", "Z0 Range (m):", min = 0.001, max = 0.5, value = c(0.001, 0.5)),
      selectInput("combinations", "Height Combinations:", 
                  choices = c("40_60_80", "40_60_100", "60_80_100"),
                  selected = "40_60_80", multiple = TRUE),
      textInput("mast_name", "Mast Name:", value = "Test Mast"),
      actionButton("analyze", "Run Analysis", class = "btn-primary")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Results", 
                 h3("Analysis Results"),
                 plotOutput("shearPlot"),
                 tableOutput("summaryTable")),
        tabPanel("Documentation", 
                 h3("How to Use This Tool"),
                 p("This Shiny application provides wind shear analysis with various methodologies:"),
                 tags$ul(
                   tags$li("Constant method - computes a single shear profile for the entire dataset"),
                   tags$li("Time series method - computes shear profiles for each timestamp"),
                   tags$li("Monthly method - computes shear profiles for each month"),
                   tags$li("Hourly method - computes shear profiles for each hour of the day"),
                   tags$li("Directional method - computes shear profiles for different wind directions")
                 ),
                 p("Upload your data and configure the parameters to begin the analysis.")
                )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {
  # Reactive expression for analysis
  results <- eventReactive(input$analyze, {
    # Placeholder for the actual analysis
    # In a real implementation, this would call your get_extrapolation_data function
    
    # For demo purposes, generate sample data
    heights <- as.numeric(unlist(strsplit(input$combinations[1], "_")))
    
    # Sample dataframe that mimics the output of your function
    data.frame(
      Law = rep(c("power", "log"), each = 3),
      Method = rep(c("Constant", "Month", "Hour"), 2),
      `Height [M]` = input$height,
      `Windspeed [m/s]` = runif(6, 6, 10),
      `MoMM [m/s]` = runif(6, 5.8, 9.8)
    )
  })
  
  # Render the analysis plot
  output$shearPlot <- renderPlot({
    req(results())
    
    # Generate a sample wind shear profile plot
    # This is a placeholder - your actual implementation would use real data
    heights <- seq(0, 200, by = 10)
    
    # Sample power law profile
    ws_base <- 7
    alpha <- 0.25
    power_law <- ws_base * (heights/100)^alpha
    
    # Create plot
    ggplot() +
      geom_line(aes(x = heights, y = power_law, color = "Power Law"), size = 1.2) +
      geom_point(aes(x = results()$`Height [M]`, y = results()$`Windspeed [m/s]`, 
                     shape = results()$Method, color = results()$Law), size = 3) +
      labs(title = paste("Wind Shear Profile -", input$mast_name),
           x = "Height (m)",
           y = "Wind Speed (m/s)",
           color = "Law Type",
           shape = "Method") +
      theme_bw() +
      theme(legend.position = "bottom",
            plot.title = element_text(face = "bold", size = 16))
  })
  
  # Render the summary table
  output$summaryTable <- renderTable({
    req(results())
    results()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
