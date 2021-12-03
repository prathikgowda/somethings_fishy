# Load R packages
library(shiny)

# Define UI
ui <- fluidPage(
                navbarPage(
                  "Group 2: CSC-324",

                  # Introduction Panel
                  tabPanel("Introduction",
                           mainPanel(
                             h1("Something's Fishy"),
                             h3("Project Background"),
                             h4("For our project, we decided to dig into global fishing data. By gathering data on where
                                fishing was concentrated, we hoped to find which countries contributed to overfishing the most.")
                           )
                           
                  ),
                  
                  # Development
                  tabPanel("Development",
                           mainPanel(
                             h1("Journey Map"),
                             h4("Here is our Journey Map detailing the story of Environemnental Erin!"),
                             img(src = "journeymap.png"),
                             
                             h1("Process Map"),
                             h4("Here is our process map detailing our developement process!"),
                             img(src = "process_map.png"),
                             
                             h1("Wireframes"),
                             h4("Here are our wireframes which we used during development"),
                             img(src = "wireframe_1.png"),
                             img(src = "wireframe_2.png"),
                             img(src = "wireframe_3.png"),
                             img(src = "wireframe_4.png"),
                             img(src = "wireframe_5.png"),
                             img(src = "plot.png")
                             
                           )
                  ),
                  
                  # Graphs Panel
                  tabPanel("Graphs", "asdfas;ldkjfa;lskd"),
                  
                  # Reflections
                  tabPanel("Reflections", "asdf;lkajsd;flak")
                  
                ) # navbarPage
) # fluidPage

# Define server function  
server <- function(input, output, session) {
  output$txtout <- renderText({
    paste( input$txt1, input$txt2, sep = " " )
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)