#' ---
#' title: "AWS prices import library for R"
#' author: "Denys Liubyvyi, dvl2110@columbia.edu"
#' ---

#load json library
if (!'RJSONIO' %in% installed.packages()) install.packages('RJSONIO')
library('RJSONIO') 

# url with some information about project in Andalussia
url <- 'http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js'

# read url and convert to data.frame
data_code <- readLines(url)
data_code_cleaned <- data_code[6]
data_code_cleaned <- gsub('([a-zA-Z_0-9\\.]*\\()|(\\);?$)',"", data_code_cleaned, perl = TRUE)
data_code_cleaned <- gsub('({)(\\w+)(:)','{\"\\2\":', data_code_cleaned, perl = TRUE)
data_code_cleaned <- gsub('(,)(\\w+)(:)',',\"\\2\":', data_code_cleaned, perl = TRUE)
data <- (fromJSON(data_code_cleaned))

#extract AWS information from the JSON
aws_columns <- data$config$valueColumns
aws_regions <- data$config$regions$region

#create table with regions, specifications and prices
aws_prices <- {}
for (i in 1:length(aws_regions)) {
    aws_regions_data <- data$config$regions$instanceTypes[i]
    aws_types <- aws_regions_data[[1]]$type
    aws_sizes <- aws_regions_data[[1]]$sizes
    n <- length(aws_sizes)
    aws_info <- {}
    for (j in 1:n) {
        temp_aws <- cbind(Type=aws_types[j],aws_regions_data[[1]]$sizes[[j]])
        aws_info <- rbind(aws_info,temp_aws)
    }
    name_price <- data.frame(matrix(unlist(aws_info[,dim(aws_info)[2]]),nrow=dim(aws_info)[1],byrow=TRUE))
    names(name_price) <- c('name','prices.USD')
    aws_info_full <- cbind(region=aws_regions[i],aws_info[,-dim(aws_info)[2]],name_price)
    aws_prices <- rbind(aws_prices,aws_info_full)
}




