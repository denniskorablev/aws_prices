# ui.R
#
source('aws_data_import.R')

shinyUI(fluidPage(
    titlePanel("AWS Prices"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Amazon Web Services price table"),
            
            selectInput("region", 
                        label = "Region",
                        choices = aws_regions,
                        selected = aws_regions[1]),
            
            sliderInput("vCPU", 
                        label = "vCPU:",
                        min = 1, max = 36, value = c(1,36)),
            
            sliderInput("price", 
                        label = "Price (USD):",
                        min = 0.01, max = 8.20, value = c(0, 8.2)),
            
            
            checkboxGroupInput('show_vars', 'Columns in table to show:',
                               names(aws_prices_df), selected = names(aws_prices_df)[3:9])
            
        ),
        
        mainPanel(
            dataTableOutput('mytable3')
        )
    )
))