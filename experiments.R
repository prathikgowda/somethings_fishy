# Load packages
library(tidyverse) # for general data wrangling and plotting
library(furrr) # for parallel operations on lists
library(lubridate) # for working with dates
library(sf) # for vector data 
library(raster) # for working with rasters
library(maps) # additional helpful mapping packages
library(maptools)
library(rgeos)

# Specify location of data directory
effort_data_dir <- '~/somethings_fishy/dataset/mmsi-daily-csvs-10-v2-2020'
vessel_data_file <- '~/somethings_fishy/dataset/vessel/fishing-vessels-v1-5.csv'

# Create dataframe of filenames dates and filter to date range of interest
effort_files <- tibble(
  file = list.files(effort_data_dir, 
                    pattern = '.csv', recursive = T, full.names = T),
  date = ymd(str_extract(file, 
                         pattern = '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')))

effort_dates <- seq(ymd('2020-01-01'), ymd('2020-12-31'), by='days')

# Read in data (uncomment to read in parallel)
plan(multisession) # Windows users should change this to plan(multisession)
effort_df <- furrr::future_map_dfr(effort_files$file, .f = read_csv)

vessel_df <- read.csv(file = vessel_data_file)

# Add date information
effort_df <- effort_df %>% 
  mutate(year  = year(date),
         month = month(date))

# Specify new (lower) resolution in degrees for aggregating data
res <- 0.25

# Transform data across all fleets and geartypes
effort_df <- effort_df %>% 
  mutate(
    # convert from hundreths of a degree to degrees
    cell_ll_lat = cell_ll_lat / 100, 
    cell_ll_lon = cell_ll_lon / 100,
    # calculate new lat lon bins with desired resolution
    cell_ll_lat = floor(cell_ll_lat/res) * res + 0.5 * res, 
    cell_ll_lon = floor(cell_ll_lon/res) * res + 0.5 * res)


# Use a join to combine the effort table and vessel table by MMSI
combined_df <- inner_join(effort_df, vessel_df, by=c("mmsi"))


##### MAP STUFF #####

# World polygons from the maps package
world_shp <- sf::st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))

# # Load EEZ polygons
# eezs <- read_sf('~/data/shapefiles/World_EEZ_v10_20180221/', layer = 'eez_v10') %>% 
#   filter(Pol_type == '200NM') # select the 200 nautical mile polygon layer

# Aggregate data across all fleets and geartypes
effort_all <- combined_df %>% 
  group_by(cell_ll_lat,cell_ll_lon) %>% 
  summarize(fishing_hours = sum(fishing_hours, na.rm = T),
            log_fishing_hours = log10(sum(fishing_hours, na.rm = T))) %>% 
  ungroup() %>% 
  mutate(log_fishing_hours = ifelse(log_fishing_hours <= 1, 1, log_fishing_hours),
         log_fishing_hours = ifelse(log_fishing_hours >= 5, 5, log_fishing_hours)) %>% 
  filter(fishing_hours >= 24)



# Linear green color palette function
effort_pal <- colorRampPalette(c('#0C276C', '#3B9088', '#EEFF00', '#ffffff'), 
                               interpolate = 'linear')

# Map fishing effort
p1 <- effort_all %>%
  ggplot() +
  geom_sf(data = world_shp, 
          fill = '#374a6d', 
          color = '#0A1738',
          size = 0.1) +
  geom_raster(aes(x = cell_ll_lon*100, y = cell_ll_lat*100, fill = log_fishing_hours)) +
  scale_fill_gradientn(
    "Fishing Hours",
    na.value = NA,
    limits = c(1, 5),
    colours = effort_pal(5), # Linear Green
    labels = c("10", "100", "1,000", "10,000", "100,000+"),
    values = scales::rescale(c(0, 1))) +
  labs(fill  = 'Fishing hours (log scale)',
       title = 'Global fishing effort in 2016') +
  guides(fill = guide_colourbar(barwidth = 10))






