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
                             
                             h1("Plot"),
                             h4("Here is our plot of global fishing efforts in 2020"),
                             img(src = "plot.png")
                           )
                  ),
                  
                  # Graphs Panel
<<<<<<< Updated upstream
                  tabPanel("Graphs",
                           mainPanel(
                             h4("We utilized two datasets, which we combined, to create a visualization of
                                fishing efforts worldwide. This graph shows us where fishing is most concentrated,
                                which may be helpful to environmentalists who are interested in the problem of
                                overfishing."),
                           )
                  ),
=======
                  tabPanel("Graphs", mainPanel(
                    plotOutput("plot", width = "400px")
                  )),
>>>>>>> Stashed changes
                  
                  # Reflections
                  tabPanel("Reflections", 
                           mainPanel(
                             h1("Tommy's Reflection"),
                             h4("[insert tommy's reflection here]"),
                             
                             h1("Jeev's Reflection"),
                             h4("[Insert Jeev's reflection here"),
                             
                             h1("Prathik's Reflection"),
                             h4("[Insert Prathik's Reflection here"),
                           )
                  )
                  
                ) # navbarPage
) # fluidPage

# Define server function  
server <- function(input, output, session) {
  source("experiments.R")
  output$plot <- renderPlot(p1)
}

# Create Shiny object
shinyApp(ui = ui, server = server)