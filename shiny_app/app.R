# Load R packages
library(shiny)

# Define UI
ui <- fluidPage(
                navbarPage(
                  "Group 2: CSC-324",
                  tabPanel("Introduction",
                           mainPanel(
                             h1("Something's Fishy\n\n"),
                             h3("Project Background\n\n"),
                             h4("Dataset\n\n"),
                             verbatimTextOutput("txtout")
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Data", "agalsdjf;alksjdf"),
                  tabPanel("Graphs", "asdfas;ldkjfa;lskd"),
                  tabPanel("Reflections", "asdf;lkajsd;flak")
                  
                ) # navbarPage
) # fluidPage

# Define server function  
server <- function(input, output) {
  
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " " )
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)