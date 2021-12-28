# Load packages
library(tidyverse) # for general data wrangling and plotting
library(furrr) # for parallel operations on lists
library(lubridate) # for working with dates
library(sf) # for vector data 
library(raster) # for working with rasters
library(maps) # additional helpful mapping packages
library(maptools)
library(rgeos)

library(DBI)
library(bigrquery)

if (FALSE) {
    bq_auth(path = "auth/somethings-fishy-4b55f5c190c0.json")
}

# Store the project id
projectid <- "somethings-fishy"

# Set your query
sql <- "
SELECT
    vessels.mmsi,
    cell_ll_lat,
    cell_ll_lon,
    vessel_class_gfw,
    fishing_hours,
    flag_gfw
FROM 
    `global-fishing-watch.gfw_public_data.fishing_effort_byvessel_v2` AS efforts
LEFT JOIN 
    `global-fishing-watch.gfw_public_data.fishing_vessels_v2` AS vessels
ON efforts.mmsi = vessels.mmsi
WHERE 
LIMIT 10000
"

tb <- bq_project_query(projectid, sql)

# Run the query and store the data in a tibble
combined_df <- as.data.frame(bq_table_download(tb))

# World polygons from the maps package
world_shp <- sf::st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))

# Aggregate data across all fleets and geartypes
effort_all <- combined_df %>% 
    filter(flag_gfw %in% c('CHN')) %>%
    group_by(cell_ll_lat, cell_ll_lon, flag_gfw) %>% 
    summarize(fishing_hours = sum(fishing_hours, na.rm = T))



# Linear green color palette function
effort_pal <- colorRampPalette(c('#0C276C', '#3B9088', '#EEFF00', '#ffffff'), 
                               interpolate = 'linear')

# Map fishing effort
p1 <- effort_all %>%
    ggplot() +
    geom_sf(data = world_shp, 
            color = '#374a6d',
            size = 0.1) +
    geom_tile(aes(x = cell_ll_lon, y = cell_ll_lat, fill = fishing_hours)) +
    scale_fill_gradientn(
        "Fishing Hours",
        na.value = NA,
        limits = c(1, 5),
        colours = effort_pal(5), # Linear Green
        labels = c("10", "100", "1,000", "10,000", "100,000+"),
        values = scales::rescale(c(0, 1))) +
    labs(fill  = 'Fishing hours (log scale)',
         title = 'Global fishing effort in 2020') +
    guides(fill = guide_colourbar(barwidth = 10)) +
    theme(panel.background = element_rect(fill = '#061530'))

# 
# png(file="~/somethings_fishy/shiny_app/www/plot.png", width=2000, height=1300)
# p1
# dev.off()










