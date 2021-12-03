# Load R packages
library(shiny)

ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  source("experiments.R")
  output$plot <- renderPlot(p1)
}


# Create Shiny object
shinyApp(ui = ui, server = server)