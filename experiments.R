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
effort_data_dir <- 'dataset/mmsi-daily-csvs-10-v2-2020'
vessel_data_file <- 'dataset/vessel/fishing-vessels-v1-5.csv'

# Create dataframe of filenames dates and filter to date range of interest
effort_files <- tibble(
  file = list.files(effort_data_dir, 
                    pattern = '.csv', recursive = T, full.names = T),
  date = ymd(str_extract(file, 
                         pattern = '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')))

effort_dates <- seq(ymd('2020-01-01'), ymd('2020-12-31'), by='days')

# Read in data (uncomment to read in parallel)
plan(multiprocess) # Windows users should change this to plan(multisession)
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

