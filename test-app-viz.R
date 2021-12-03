# Load R packages
library(shiny)

source("experiments.R")

# Define UI
ui <- fluidPage(
  navbarPage(
    "Group 2: CSC-324",
    tabPanel("Introduction",
             mainPanel(
               h3("Project Background\n\n"),
               plotOutput(
                 p1,
                 width = "100%",
                 height = "400px",
                 click = NULL,
                 dblclick = NULL,
                 hover = NULL,
                 brush = NULL,
                 inline = FALSE
               ),
               h4("Dataset\n\n"),
               verbatimTextOutput("txtout")
             ) # mainPanel
             
    ), # Navbar 1, tabPanel
    tabPanel("Data", "agalsdjf;alksjdf"),
    tabPanel("Graphs", "asdfas;ldkjfa;lskd"),
    tabPanel("Reflections", "asdf;lkajsd;flak")
    
  ) # navbarPage
) # fluidPage
# Create Shiny object
shinyApp(ui = ui, server = server)