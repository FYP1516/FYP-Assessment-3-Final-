install.packages("viridis")
install.packages("devtools")
install.packages("stringi")
library(devtools)
devtools::install_github("ropensci/plotly")

install.packages("plotly")
library(plotly)

plotly(username="FYProj1516", key="km036numx3")

BMI1 <- runif(400,10,20)

BMI2 <- runif(300,20,30)

BMI3 <- runif(300,30,40)

BMI <- c(BMI1,BMI2,BMI3)

BMIframe <- as.data.frame(BMI)

BMIframe$color <- ifelse (BMIframe$BMI >= 10 & BMIframe$BMI < 20, "green" , 
                          ifelse(BMIframe$BMI >= 20 & BMIframe$BMI < 30, "yellow","red"))

q <- matrix(BMI, nrow = 1000, ncol = 2)

plot_ly(z = q, colors = BMIframe$color, type = "surface")
