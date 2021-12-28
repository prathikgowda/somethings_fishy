# Load R packages
library(shiny)
library(shinythemes)
library(shinydashboard)
library(DBI)
library(bigrquery)
library(rsconnect)
library(readr)

bq_auth(path = "somethings-fishy-4b55f5c190c0.json")

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

    # INTRODUCTION PANEL
    tabPanel("Introduction",
              fluidRow(
                column(6, img(src="fish.jpeg")),
                column(5,
                h1("Something's Fishy"),
                hr(),
                h3("Project Background"),
                h4("Who: Fish"),
                h4("What: Are being fished at unknown rates"),
                h4("When: 2020"),
                h4("Where: All around the world"),
                h4("Why: To feed the people"),
                h4("How: By different types of fishing vessels"),
                hr(),
                h3("Project Overview"),
                p("This Shiny app was inspired by the ",
                   a(href = 'https://globalfishingwatch.org', 'Global Fishing Watch', .noWS = "outside"), 
                  "
                  and some of the data that they have available 
                  to download. The Global Fishing Watch has lots 
                  of data that can be hard to interpret and 
                  visualize without using a type of program 
                  (such as Shiny/R). Our goal was to provide 
                  those visualizations to those who might not 
                  be tech-savvy, but would like to observe the 
                  data in a format that is not millions of rows 
                  in an Excel spreadsheet. ")
              ),
              
              
            )
              
    ),
                  
    # DATA PANEL
    tabPanel("Data",
      fluidRow(
        column(9,
          titlePanel("Dataset & variables"),
          hr(),
          p("The data that was used for this Shiny app was 
            retrieved from ", 
            a(href = 'https://globalfishingwatch.org/datasets-and-code/', 'Global Fishing Watch: Transparency for a Sustainable Ocean', .noWS = "outside"), 
            ". We 
            utilized two of the datasets labeled, 
            'fishing-vessels-v1-5.csv' and 
            'mmsi-daily-csvs-10-v2-2020.zip'. The fishing 
            dataset has 19 variables but we will only talk 
            about a few of them: "),
          h4("MMSI: this is the unique identifier for each 
            fishing vessel"),
          h4("Flag: this is the country that the vessel is 
            from"),
          h4("Vessel_class: is which class that the finishing
            vessel belongs (fishing, trawlers, squid_jigger,
            etc)"),
          hr(),
          p("There are many more variables but are not 
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
          br(),
          p("Using these variables, we are able to match up 
          each country with the amount of fishing hours they 
          have and where they are fishing the most. It is 
          crucial that we match these datasets together to 
          have the ‘flag’ of the fishing vessel.")
      ),
      column(3, img(src = "gfw_logo.png")))
    ),

    # Development
    tabPanel("Development",
      titlePanel("Development process"),
      hr(),
      tags$div(class="grid", 
        h3("Process map"),
        fluidRow(
          column(7, 
            p("This process map was our initial plan on what 
                  we wanted to do when we set out on this journey.
                  Although it was fairly vague, we wanted it to be
                  this way so we can make any necessary changes, 
                  since it was early on in the development 
                  process." ),
            p(
              "It was a big help to include this 
              process map because it forced us to set 
              checkmarks for our project. By doing this, we 
              always had a good idea of what we had left to 
              do."),
          ),
          column(5, 
            img(src = "process_map.png", style="max-height: 400px;"),
          )
        ),
        hr(),
        h3("Journey map"),
        fluidRow(
          column(6,
            p("The journey map was another important piece of 
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
            p("By taking a look at this potential consumer, 
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
          ),
          column(6,
            img(src = "journey_map.png")
          )
        ),
      br(),
      hr(),
      h3("Wireframes"),
      p("The wireframe is an initial sketch of what we 
                  want our screen mockup and eventually our app 
                  to look like. The wireframe allows us to put 
                  all our ideas onto paper so we do not have to 
                  attempt to put it on the screen mockup when we 
                  are unsure of what Shiny is and is not capable 
                  of. Using the ideas that we have come up with by
                  using the journey map, we sketch those onto the 
                  paper to finalize our wireframe."),
      br(),
      fluidRow(
        column(2, img(src = "wireframe_1.png")),
        column(2, img(src = "wireframe_2.png")),
        column(2, img(src = "wireframe_3.png")),
        column(2, img(src = "wireframe_4.png")),
        column(2, img(src = "wireframe_5.png")),
      ),
      br(),
        hr(),
        h3("Screen mockup"),
        fluidRow(
          column(6,
            p("In the screen mockup, we are attempting to make the very base of our app.
            We are starting to use Shiny to work on the UI of the app.
            We have taken our wireframe and put that into Shiny.
            However, our screen mockup did not line up directly to the wireframe.
            This is because we have worked with Shiny to find what worked well and what was not so feasible.
            We also just decided to make some changes to the app to make it flow better.
            Now that we have the bones of the app, we are ready to start adding in the text and data.")
          ),
          column(6,
            img(src = "mockup.png")
          )
        ),        
      ),
      br(),
      br(),
      br()
    ),

    # Graphs Panel
    tabPanel(
      "Graphs",
      titlePanel("Graphs & visualizations"),
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
                  "Set Longline" = "set_longlines",
                  "Set Gillnet" = "set_gillnets",
                  "Fixed Gea" = "fixed_gear",
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
                Using 50 million rows from Global Fishing Watch's fishing effort and registered vessels datasets,
                we can map all locations of fishing activity in the year 2020 and plot these datapoints on a world map."
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
            we can examine the number of fishing hours by country of origin,
            and see how this number changes each year, as plotted on the cartogram."
          ),
          hr(),
          img(src = "cartogram.gif"),
        )
      ),
    ),
    
    # Reflections
    tabPanel("Reflections & References", 
      titlePanel("Reflections & References"),
      h3("Our reflections"),
      hr(),
      p(tags$strong("Tommy:")),
      p("I have found that it is crucial to work well as a group when doing any type of software development. It was fun to see the visualizations come together as we worked hard to get them operational. I started to use Github which was fun and R is a language that is very powerful that can do many things. There is also a lot more to making an app than I realized."),
      p(tags$strong("Jeev:")),
      p("I learned a lot about how to develop R Shiny applications. It was also challenging to work with an extremely large dataset, especially since running simple R functions would take up gigabytes of memory on my computer. Ultimately, the decision to host data using BigQuery in the cloud made it significantly easier to create the visualizations we wanted to. It was productive to divide tasks amongst the members of our group, allowing each of us to specialize on a different part of the app."),
      p(tags$strong("Prathik:")),
      p("I learned the importance of communication in a group project. Clearly designating roles for members of our group helped us better divide tasks and coordinate our project development. I also learned about the difficulty of creating a web application - which is something I have never worked on before."),
      p(tags$strong("Steven:")),
      p("I learned a lot in making software with a group. As my first experience of making a software, I learned the difficulty of the whole process, but it is also a lot of fun to complete it with group members. I also learned how to use Github and the R language in this process."),
      hr(),
      h3("Future opportunities"),
      p("There are many future research opportunities that can come from this project with the addition of more data. One of the ideas that we had was to compare what fish vessels were fishing and compare it to the consumption of that fish in the country that the vessel belongs to. However, we came up with that idea a bit too late and we were not able to find any data and it, so it was not feasible with the time constraints we had."),
      hr(),
      h3("References"),
      p("
      We would like to thank Global Finishing Watch.
      They are the owners of the data that we used and provided some code in R that got us started to
      analyze the data in an efficient way. We would also like to thank our professor,
      Fernanda Eliott, for helping us with ideas as well as implementation in Shiny.
      Finally, we wish to thank our alumni mentor, Wesley, for his feedback during the development process."),
      hr(),
      h3("Packages used"),
      p("Below are a list of the packages we used in our Shiny app."),
      tags$ul(
        tags$li(tags$pre("tidyverse")),
        tags$li(tags$pre("shiny")), 
        tags$li(tags$pre("shinythemes")),
        tags$li(tags$pre("shinydashboard")),
        tags$li(tags$pre("DBI")),
        tags$li(tags$pre("bigrquery")),
        tags$li(tags$pre("lubridate")),
        tags$li(tags$pre("furrr")),
        tags$li(tags$pre("sf")),
        tags$li(tags$pre("raster")),
        tags$li(tags$pre("maps")),
        tags$li(tags$pre("cartogram")),
        tags$li(tags$pre("rsconnect")),
      )
)
                  
   # navbarPage
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