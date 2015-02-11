library(jsonlite)

# url with some information about project in Andalussia
url <- 'http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js'

# read url and convert to data.frame
con = file(url, "r")
data_code <- readLines(con)
aws_data <- fromJSON(txt=data_code[6],force=TRUE)
close(con)