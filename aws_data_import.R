#' ---
#' title: "AWS prices import library for R"
#' author: "Denys Liubyvyi, dvl2110@columbia.edu"
#' ---

#load json library
if (!'RJSONIO' %in% installed.packages()) install.packages('RJSONIO')
library('RJSONIO') 


# read url and convert to data.frame
url <- 'http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js'
data_code <- readLines(url)
data_code_cleaned <- data_code[6]
data_code_cleaned <- gsub('([a-zA-Z_0-9\\.]*\\()|(\\);?$)',"", data_code_cleaned, perl = TRUE) #eliminate function call
data_code_cleaned <- gsub('({)(\\w+)(:)','{\"\\2\":', data_code_cleaned, perl = TRUE) #add quotes
data_code_cleaned <- gsub('(,)(\\w+)(:)',',\"\\2\":', data_code_cleaned, perl = TRUE) #add quotes
data <- (fromJSON(data_code_cleaned))

#extract AWS information from the JSON
aws_columns <- data$config$valueColumns

#extract list of regions from JSON
aws_regions <- {}
for (i in 1:length(data$config$regions)) {
    aws_regions <- c(aws_regions,data$config$regions[[i]]$region)
}

#create table with regions, specifications and prices
aws_prices <- {} 
for (i in 1:length(aws_regions)) {
    aws_regions_data <- data$config$regions[[i]]$instanceTypes #extract data for specific region
    #aws_sizes <- aws_regions_data[[i]]$sizes # extract data for different server sizes 
    #n_sizes <- length(aws_sizes) #store number of server sizes
    
    # extract server types
    aws_types <- {} 
    for (j in 1:length(aws_regions_data)) {
        aws_types <- c(aws_types,aws_regions_data[[j]]$type)
    }
    n_types <- length(aws_types) # store number of server types
    
    #extract detailed server info
    aws_info <- {}
    
    for (j in 1:n_types) { #loop for server types
        aws_sizes <- aws_regions_data[[j]]$sizes
        aws_info_for_region_and_size <- {}
        for (k in 1:length(aws_sizes)) { #loop for server sizes
            aws_info_for_region_and_size <- rbind(aws_info_for_region_and_size,unlist(aws_regions_data[[j]]$sizes[k])[1:7])
        }
        temp_aws <- cbind(type=aws_types[j],aws_info_for_region_and_size)
        aws_info <- rbind(aws_info,temp_aws)
    }
    aws_info_full <- cbind(region=aws_regions[i],aws_info)
    aws_prices <- rbind(aws_prices,aws_info_full)
}
colnames(aws_prices)[8:9] <- c('OS','USD')
head(aws_prices)
aws_prices_df <- data.frame(
    region=as.character(aws_prices[,1]),
    type=as.character(aws_prices[,2]),
    size=as.character(aws_prices[,3]),
    vCPU=as.double(aws_prices[,4]),
    ECU=as.character(aws_prices[,5]),
    memoryGiB=as.double(aws_prices[,6]),
    storageGB = as.character(aws_prices[,7]),
    OS = as.character(aws_prices[,8]),
    USD = as.double(aws_prices[,9])
    )

#our final data object
head(aws_prices_df)
range(na.omit(aws_prices_df$USD)) #price range per hour

