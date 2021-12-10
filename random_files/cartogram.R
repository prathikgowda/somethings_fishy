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
    SUM(fishing_hours_2016) as total_hrs_2016,
    SUM(fishing_hours_2017) as total_hrs_2017,
    SUM(fishing_hours_2018) as total_hrs_2018,
    SUM(fishing_hours_2019) as total_hrs_2019,
    SUM(fishing_hours_2020) as total_hrs_2020,
    flag_gfw as flag,
    COUNT(*) AS num_vessels,
    SUM(fishing_hours_2016) / COUNT(*) as avg_hrs_per_vessel_2016
FROM
    `global-fishing-watch.gfw_public_data.fishing_vessels_v2` AS vessels

GROUP BY flag_gfw
HAVING count(*) > 0

ORDER BY SUM(fishing_hours_2016) DESC
"

tb <- bq_project_query(projectid, sql)

# Run the query and store the data in a tibble
df <- as.data.frame(bq_table_download(tb))

df2 <- df
names(df2) <- gsub('total_hrs_', '', names(df2))

df2$indicator = "num_vessels"

df2 <- df2 %>% na.omit() %>% 
  gather(key = "year", value = "num_vessels", `2016`:`2020`) %>% 
  mutate(year = as.integer(year)) 


world_map = ne_countries(returnclass = "sf")
world_map <- world_map[,c("iso_a3","geometry")]
world_map <- st_transform(world_map, crs = "+proj=robin")

world_data = dplyr::left_join(world_map, df2, by = c("iso_a3"="flag"))  


world_data_yearly = world_data %>%
  filter(year == 2020)

world_carto = cartogram_cont(world_data_yearly, "num_vessels", 
                              itermax = 15, maxSizeError = 1.0001,
                              prepare = "adjust", threshold = 0.05)

# plot(st_geometry(world_carto["num_vessels"]))
plot(st_geometry(world_carto), col = sf.colors(20, categorical = TRUE),
     border="grey",
     axes = FALSE)


tm_polygons("under_pop", title = "Undernourished Population: ") +
  tm_facets(along = "title", free.coords = FALSE, drop.units = TRUE)+
  tm_layout(legend.outside.position = "right", legend.outside = TRUE)
