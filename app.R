# Load R packages
library(shiny)
library(shinythemes)
library(shinydashboard)
library(DBI)
library(bigrquery)

if (FALSE) {
  bq_auth(path = "auth/somethings-fishy-4b55f5c190c0.json")
}

# Store the project id
projectid <- "somethings-fishy"

# Set your query
sql <- "
  SELECT DISTINCT
      mmsi,
      flag_gfw AS flag,
      vessel_class_gfw AS vessel_class,
      length_m_gfw AS vessel_length_meters,
      fishing_hours_2020 AS fishing_hours
  FROM
      `global-fishing-watch.gfw_public_data.fishing_vessels_v2` AS vessels
  ORDER BY fishing_hours_2020 DESC
  LIMIT 10000
"

tb <- bq_project_query(projectid, sql)

# Run the query and store the data in a tibble
df <- as.data.frame(bq_table_download(tb))


# Define UI
ui <-
  
  navbarPage(
    # theme = shinytheme("sandstone"),
    tags$head(  
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),

<<<<<<< Updated upstream
                  # INTRODUCTION PANEL
                  tabPanel("Introduction",
                           mainPanel(
                             h1("Something's Fishy"),
                             
                             h3("Project Background"),
                             h4("Who: Fish"),
                             h4("What: Are being fished at unknown rates"),
                             h4("When: 2020"),
                             h4("Where: All around the world"),
                             h4("Why: To feed the people"),
                             h4("How: By different types of fishing vessels"),
                             
                             h3("Project Overview"),
                             h4("This Shiny app was inspired by the Global 
                                Fishing Watch (https://globalfishingwatch.org) 
                                and some of the data that they have available 
                                to download. The Global Fishing Watch has lots 
                                of data that can be hard to interpret and 
                                visualize without using a type of program 
                                (such as Shiny/R). Our goal was to provide 
                                those visualizations to those who might not 
                                be tech-savvy, but would like to observe the 
                                data in a format that is not millions of rows 
                                in an Excel spreadsheet. ")
                           )
                           
                  ),
                  
                  # DATA PANEL
                  tabPanel("Data",
                           mainPanel(
                             h1("The Data"),
                             h4("The data that was used for this Shiny app was 
                                retrieved from the Global Fishing Watch: 
                                Transparency for a Sustainable Ocean. We 
                                utilized two of the datasets labeled, 
                                'fishing-vessels-v1-5.csv' and 
                                'mmsi-daily-csvs-10-v2-2020.zip'. The fishing 
                                dataset has 19 variables but we will only talk 
                                about a few of them. "),
                             h4("MMSI: this is the unique identifier for each 
                                fishing vessel"),
                             h4("Flag: this is the country that the vessel is 
                                from"),
                             h4("Vessel_class: is which class that the finishing
                                vessel belongs (fishing, trawlers, squid_jigger,
                                etc)"),
                             h4("There are many more variables but are not 
                                necessary when looking at our data. The most 
                                important variables here are the MMSI and flag 
                                variables. Looking at our other dataset, 
                                'mmsi-daily-csvs-10-v2-2020.zip’, we are able 
                                to see the fishing done on a daily basis. The 
                                .zip file has daily data from 2020 and uses the
                                same MMSI identifier for each fishing vessel. 
                                Because of this, we can match the datasets 
                                together to make informative visualizations. 
                                There were 6 variables in the 
                                'mmsi-daily-csvs-10-v2-2020.zip’ dataset."),
                             h4("  1. date, which was the same all throughout 
                                the file (since it was daily info)"),
                             h4("  2. Cell_ll_lat: which was the latitude of the
                                fishing vessel"),
                             h4("  3. Cell_ll_lon: which was the longitude of 
                             the fishing vessel"),
                             h4("  4. Mmsi: which is the unique identifier for 
                                each fishing vessel"),
                             h4("  5. Hours: the hours spent on the water"),
                             h4("  6. Fishing_hours: the hours spent fishing"),
                             h4("Using these variables, we are able to match up 
                             each country with the amount of fishing hours they 
                             have and where they are fishing the most. It is 
                             crucial that we match these datasets together to 
                             have the ‘flag’ of the fishing vessel.")
                           )
                  ),
                  
                  # DEVELOPMENT PANEL
                  tabPanel("Development",
                           mainPanel(
                             
                             h1("Process Map"),
                             h4("This process map was our initial plan on what 
                                we wanted to do when we set out on this journey.
                                Although it was fairly vague, we wanted it to be
                                this way so we can make any necessary changes, 
                                since it was early on in the development 
                                process. It was a big help to include this 
                                process map because it forced us to set 
                                checkmarks for our project. By doing this, we 
                                always had a good idea of what we had left to 
                                do."),
                             img(src = "process_map.png"),
                             
                             h1("Journey Map"),
                             h4("The journey map was another important piece of 
                                our Shiny app puzzle. The journey map is 
                                supposed to demonstrate a potential user's 
                                journey when they are to encounter our app. 
                                In our journey map, we introduced a potential 
                                consumer named ‘Environmental Erin.’ She is one 
                                who is looking for data on overfishing and has 
                                access to the data but she is not able to 
                                interpret it in the way that it is presented. 
                                The data says to use a language called ‘R’ 
                                which she has never even heard of. She then 
                                stumbles across our app and can use the same 
                                data but in an easy and simple way. "),
                             h4("By taking a look at this potential consumer, 
                                we are able to find what should be a priority 
                                when making our user interface (UI). Since our 
                                main target audience are people who cannot 
                                utilize the data initially, we want to make it 
                                as easy as possible for people who are not as 
                                knowledgeable about technology. It is good that 
                                we looked at the journey map before the 
                                wireframe, so that when we were to make the 
                                wireframe and screen mockup, we can incorporate 
                                these ideas. "),
                             img(src = "journeymap.png"),
                             
                             h1("Wireframes"),
                             h4("The wireframe is an initial sketch of what we 
                                want our screen mockup and eventually our app 
                                to look like. The wireframe allows us to put 
                                all our ideas onto paper so we do not have to 
                                attempt to put it on the screen mockup when we 
                                are unsure of what Shiny is and is not capable 
                                of. Using the ideas that we have come up with by
                                using the journey map, we sketch those onto the 
                                paper to finalize our wireframe. We are now 
                                ready for the screen mockup."),
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
                  tabPanel("Graphs",
                           mainPanel(
                             h4("We utilized two datasets, which we combined, to create a visualization of
                                fishing efforts worldwide. This graph shows us where fishing is most concentrated,
                                which may be helpful to environmentalists who are interested in the problem of
                                overfishing."),
                           )
                  ),
                  tabPanel("Graphs", mainPanel(
                    plotOutput("plot", width = "400px")
                  )),
                  
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
=======
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
      h1("Journey Map"),
      hr(),
      tags$div(class="grid", 
        fluidRow(
          column(6, 
            h4("Here is our Journey Map detailing the story of Environemnental Erin!"),
            img(src = "journeymap.png"),
          ),
          column(6, 
            h4("Here is our process map detailing our developement process!"),
            img(src = "process_map.png"),
          )
        )
      ),
      h3("Wireframes"),
      h4("Here are our wireframes which we used during development"),
      hr(),
      tags$div(class="grid", 
        fluidRow(
          column(3, img(src = "wireframe_1.png")),
          column(3, img(src = "wireframe_2.png")),
          column(3, img(src = "wireframe_3.png")),
          column(3, img(src = "wireframe_4.png")),
          column(3, img(src = "wireframe_5.png")),
          column(3),
        ),
      )
    ),
    
    # Graphs Panel
    tabPanel(
      "Graphs",
      titlePanel("Graphs & Visualizations"),
      hr(),
      tabsetPanel(
        tabPanel(
          "Fishing activity by vessel",
          h3("Fishing activity by vessel"),
          p("
            Using Global Fishing Watch's registered vessels dataset,
            we can examine how fishing activity differs based on the class of vessel used,
            and how fishing vessel length is associated with amount of hours spent fishing."
          ),
          hr(),
          sidebarLayout(
            sidebarPanel(    
              helpText(
                "Filter by vessel class type:"
              ),
              selectInput("class", "Vessel Class:",
                c(
                  "Trawlers" = "trawlers",
                  "Fishing" = "fishing",
                  "Set Longline"  = "set_longlines",
                  "Set Gillnet"  = "set_gillnets",
                  "Fixed Gea"  = "fixed_gear",
                  "Other Purse Seines" = "other_purse_seines",
                  "Drifting Longlines" = "drifting_longlines",
                  "Pole and Line" = "pole_and_line",
                  "Dredge Fishing" = "dredge_fishing",
                  "Pots and Traps" = "pots_and_traps",
                  "Squid Jigger" = "squid_jigger",
                  "Tuna Purse Seines" = "tuna_purse_seines"
                )
              ),
              helpText(
                "Click on a point to view additional information for that vessel below."
              ),
              hr(),
              div(style = "height:200px; overflow-y: scroll; overflow-x: scroll;",
              tableOutput("data")
              )
            ),
            mainPanel(
              plotOutput("plot", click = "plot_click"),
            )
          )
        ),
        tabPanel(
          "Global fishing activity map",
          h3("Global fishing activity map"),
          fluidRow(
            column(8,
              p("
                Using Global Fishing Watch's registered vessels dataset,
                we can examine how fishing activity differs based on the class of vessel used,
                and how fishing vessel length is associated with amount of hours spent fishing."
              ),
            ),
            column(3,
              img(src = "legend.png", style="max-width: 300px; padding: 0 20px;")
            )
          ),
          hr(),
          img(src = "global_fishing_plot.png")
        ),
        tabPanel(
          "Active vessels cartogram",
          h3("Active vessels cartogram"),
          p("
            Using Global Fishing Watch's registered vessels dataset,
            we can examine how fishing activity differs based on the class of vessel used,
            and how fishing vessel length is associated with amount of hours spent fishing."
          ),
          hr(),
          img(src = "cartogram.gif"),
        )
      ),
    ),
    
    # Reflections
    tabPanel("Reflections", 
      mainPanel(
        h1("Tommy's Reflection"),
        h4("[insert tommy's reflection here]"),
        
        h1("Jeev's Reflection"),
        h4("[Insert Jeev's reflection here"),
        
        h1("Prathik's Reflection"),
        h4("[Insert Prathik's Reflection here")
      )
    )
                  
   # navbarPage
>>>>>>> Stashed changes
) # fluidPage

# Define server function  
server <- function(input, output, session) {

  output$plot <- renderPlot({
    filtered_data <- subset(df, df$vessel_class == input$class)
    plot(
      filtered_data$vessel_length_meters, 
      filtered_data$fishing_hours,
      ylab="Time spent fishing (hrs)",
      xlab="Vessel length (m)")
  }, res = 96)

  output$data <- renderTable({
    filtered_data <- subset(df, df$vessel_class == input$class)
    nearPoints(filtered_data, input$plot_click, xvar = "vessel_length_meters", yvar = "fishing_hours")
  })

}

# Create Shiny object
shinyApp(ui = ui, server = server)