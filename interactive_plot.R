# Load packages
library(tidyverse) # for general data wrangling and plotting
library(furrr) # for parallel operations on lists
library(lubridate) # for working with dates
library(sf) # for vector data 
library(raster) # for working with rasters
library(maps) # additional helpful mapping packages
library(maptools)
library(rgeos)
library(shiny)
library(ggplot2)

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



ui <- fluidPage(
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
              )),
  plotOutput("plot", click = "plot_click"),
  tableOutput("data"),
  textOutput("result")
)

server <- function(input, output, session) {
 
  output$plot <- renderPlot({
    filtered_data <- subset(df, df$vessel_class == input$class)
    plot(filtered_data$vessel_length_meters, filtered_data$fishing_hours)
  }, res = 96)
  
  output$data <- renderTable({
    filtered_data <- subset(df, df$vessel_class == input$class)
    nearPoints(filtered_data, input$plot_click, xvar = "vessel_length_meters", yvar = "fishing_hours")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)