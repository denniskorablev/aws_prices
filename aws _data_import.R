# library(jsonlite)
library(RJSONIO)

# url with some information about project in Andalussia
url <- 'http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js'

# read url and convert to data.frame


con = file(url, "r")
data_code <- readLines(con)
data_code_cleaned <- data_code[6]
json <- gsub('([a-zA-Z_0-9\\.]*\\()|(\\);?$)', "", data_code_cleaned, perl = TRUE)
data <- fromJSON(json)