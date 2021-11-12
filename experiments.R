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
data_dir <- '~/Downloads/mmsi-daily-csvs-10-v2-2020'

# Create dataframe of filenames dates and filter to date range of interest
effort_files <- tibble(
  file = list.files(data_dir, 
                    pattern = '.csv', recursive = T, full.names = T),
  date = ymd(str_extract(file, 
                         pattern = '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')))

effort_dates <- seq(ymd('2020-01-01'), ymd('2020-12-31'), by='days')


# Read in data (uncomment to read in parallel)
plan(multiprocess) # Windows users should change this to plan(multisession)
effort_df <- furrr::future_map_dfr(effort_files$file, .f = read_csv)

# Add date information
effort_df <- effort_df %>% 
  mutate(year  = year(date),
         month = month(date))


# 
# # Specify new (lower) resolution in degrees for aggregating data
# res <- 0.25
# 
# # Transform data across all fleets and geartypes
# effort_df <- effort_df %>%
#   mutate(
#     # convert from hundreths of a degree to degrees
#     lat_bin = lat_bin / 100,
#     lon_bin = lon_bin / 100,
#     # calculate new lat lon bins with desired resolution
#     lat_bin = floor(lat_bin/res) * res + 0.5 * res,
#     lon_bin = floor(lon_bin/res) * res + 0.5 * res)
# 
# # Re-aggregate the data to 0.25 degrees
# effort_df <- effort_df %>%
#   group_by(date, year, month, lon_bin, lat_bin, flag, geartype) %>%
#   summarize(vessel_hours = sum(vessel_hours, na.rm = T),
#             fishing_hours = sum(fishing_hours, na.rm = T),
#             mmsi_present  = sum(mmsi_present, na.rm = T))



# # Aggregate data across all fleets and geartypes
# effort_all <- effort_df %>% 
#   group_by(lon_bin,lat_bin) %>% 
#   summarize(fishing_hours = sum(fishing_hours, na.rm = T),
#             log_fishing_hours = log10(sum(fishing_hours, na.rm = T))) %>% 
#   ungroup() %>% 
#   mutate(log_fishing_hours = ifelse(log_fishing_hours <= 1, 1, log_fishing_hours),
#          log_fishing_hours = ifelse(log_fishing_hours >= 5, 5, log_fishing_hours)) %>% 
#   filter(fishing_hours >= 24)
# 
# # Linear green color palette function
# effort_pal <- colorRampPalette(c('#0C276C', '#3B9088', '#EEFF00', '#ffffff'), 
#                                interpolate = 'linear')
# 
# # Map fishing effort
# p1 <- effort_all %>%
#   ggplot() +
#   geom_sf(data = world_shp, 
#           fill = '#374a6d', 
#           color = '#0A1738',
#           size = 0.1) +
#   geom_sf(data = eezs,
#           color = '#374a6d',
#           alpha = 0.2,
#           fill = NA,
#           size = 0.1) +
#   geom_raster(aes(x = lon_bin, y = lat_bin, fill = log_fishing_hours)) +
#   scale_fill_gradientn(
#     "Fishing Hours",
#     na.value = NA,
#     limits = c(1, 5),
#     colours = effort_pal(5), # Linear Green
#     labels = c("10", "100", "1,000", "10,000", "100,000+"),
#     values = scales::rescale(c(0, 1))) +
#   labs(fill  = 'Fishing hours (log scale)',
#        title = 'Global fishing effort in 2016') +
#   guides(fill = guide_colourbar(barwidth = 10)) +
#   gfw_theme




