# server.R

shinyServer(function(input, output) {
    
    output$text1 <- renderText({
        paste("You have selected", input$region)
    })
    
    output$text2 <- renderText({
        paste("You have chosen a range that goes from",input$price[1], "to", input$price[2])
    })
    output$mytable3 <- renderDataTable({
        aws_prices_df[aws_prices_df$region==input$region 
                      & aws_prices_df$USD >= input$price[1] 
                      & aws_prices_df$USD <= input$price[2]
                      & aws_prices_df$vCPU >= input$vCPU[1] 
                      & aws_prices_df$vCPU <= input$vCPU[2]
                      
                      ,input$show_vars]
    })
    
}
)