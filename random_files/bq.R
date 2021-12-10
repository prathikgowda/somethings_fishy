library(bigrquery)
library(dplyr)
con <- dbConnect(
  bigrquery::bigquery(),
  project = "bigquery-public-data",
  dataset = "baseball",
  billing = "somethings-fishy"
)

dbListTables(con)
