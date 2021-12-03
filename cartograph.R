# library(cartogram)
# library(tmap)
# library(maptools)
# #> Loading required package: sp
# #> Checking rgeos availability: TRUE
# 
# data(wrld_simpl)
# 
# # keep only the african continent
# afr <- wrld_simpl
# 
# # project the map
# afr <- spTransform(afr, CRS("+init=epsg:3395"))
# # 
# # # construct cartogram
# # afr_cont <- cartogram_cont(afr, "POP2005", itermax = 5)
# # 
# # # plot it
# # tm_shape(afr_cont) + tm_polygons("POP2005", style = "equal") +
# #   tm_layout(frame = FALSE, legend.position = c("left", "bottom"))


# Library
library(cartogram)

# Load the population per states (source: https://www.census.gov/data/tables/2017/demo/popest/nation-total.html)
pop <- read.table("https://raw.githubusercontent.com/holtzy/R-graph-gallery/master/DATA/pop_US.csv", sep=",", header=T)
pop$pop <- pop$pop / 1000000

# merge both
spdf@data <- spdf@data %>% left_join(., pop, by=c("google_name"="state"))

# Compute the cartogram, using this population information
cartogram <- cartogram(spdf, 'pop')

# First look!
plot(cartogram)
