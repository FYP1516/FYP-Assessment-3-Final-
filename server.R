#library used
library(ggmap)
library(ggplot2)
library(shiny)

#getting data file
setwd("C:/Users/Student-ID/Documents/R-Programming")
list.files()
Data1 <- read.csv(file = "RandomdataMap1.csv", header = TRUE, sep = ",")

BMI <- Data1[1:100,1] 

BMIframe <- as.data.frame(BMI)

BMIframe$alpha <- ifelse (BMIframe$BMI >= 10 & BMIframe$BMI < 30, 0.5, 1)

#shiny server for display map
shinyServer(function(input, output) {
  
  
  output$SPmap <- renderPlot({
    
    sing <- get_map(location = "Singapore Polytechnic", color = "color",
                    zoom = 17, maptype = "hybrid", source = "google")
    
    BMIvalue <- reactive(input$BMIdata)
 
    BMIframe$value1 <- ifelse(BMIframe$BMI >= BMIvalue(), 1, 0)
                    
    value <- sum(BMIframe$value1)
    
    BMIframe$value2 <- ifelse(BMIframe$value1 == 1, BMIframe$BMI, 0)
                              
    lat1 <- runif(value,1.309101,1.309399)
    lat2 <- runif(value,1.309601,1.309899)
    
    long1 <- runif(value,103.779401,103.779699)
    long2 <- runif(value,103.778301,103.778599) 
    
    BMIframe$lat <- ifelse (BMIframe$value2 >= 10 & BMIframe$value2 < 30, lat1, lat2)
    lat <- BMIframe$lat
    BMIframe$long <- ifelse (BMIframe$value2 >= 10 & BMIframe$value2 < 30, long1, long2)
    long <- BMIframe$long
    
    lao <- data.frame (lat,long)
  
    s <- ggmap(sing) + geom_point(
      data = lao, 
      aes_string(x = "long", y = "lat"),
      colour ="red", 
      alpha = BMIframe$alpha
    )
    print(s)
  })
})
