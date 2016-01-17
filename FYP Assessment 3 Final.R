setwd("C:/Users/Student-ID/Documents/R-Programming")
list.files()
Data1 <- read.csv(file = "SP data.csv", header = TRUE, sep = ",")
str(Data1)

colnames(Data1) <- c("Gender","Race","Course","Foodcourtvisited","Age","Weight","Height","BMI")

model_data <- Data1

## splitting into training and test:

## 75% of the sample size
smp_size <- floor(0.75 * nrow(model_data))

## set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(model_data)), size = smp_size)

## split the data
train <- model_data[train_ind, ]
test <- model_data[-train_ind, ]

## what to use in the model
predictors <- train[,which(!names(train) %in% c("BMI","Foodcourtvisited"))]
response <- as.factor(train[,"Foodcourtvisited"])

library(randomForest)
## warning - can take a long time (30mins)
rf <- randomForest(x = predictors, y = response)

## once model done, we run it using test data and compare results to reality
predictor_test <- test[,which(!names(test) %in% c("BMI","Foodcourtvisited"))]
response_test <- as.factor(test[,"Foodcourtvisited"])

## check result on test set
prediction <- predict(rf, predictor_test)
predictor_test$correct <- as.character(prediction) == as.character(response_test)

## How many were correct?
table(as.character(prediction) == as.character(response_test)) 
accuracy <- sum(predictor_test$correct) / nrow(predictor_test)

## function to get plot data format
getCompareTable <- function (test_data, prediction) {
  require(dplyr)
  
  ## plot real vs model bought Food court visited
  actual_freq <- table(model_data$Foodcourtvisited)
  predicted_freq <- table(prediction)
  
  actual_freq <- actual_freq[order(actual_freq)]
  predicted_freq <- predicted_freq[order(predicted_freq)]
  
  actual_freq_s <- data.frame(foodcourt = names(actual_freq), 
                              actual = as.vector(actual_freq), 
                              stringsAsFactors = F)
  
  predicted_freq_s <- data.frame(foodcourt = names(predicted_freq),
                                 predict = as.vector(predicted_freq),
                                 stringsAsFactors = F)
  
  actual_freq_s$actual <- unname(actual_freq_s$actual)
  predicted_freq_s$predict <- unname(predicted_freq_s$predict)
  
  compare <- dplyr::left_join(actual_freq_s, predicted_freq_s, by = "foodcourt")
  compare
}

## use function to get plot data
compare <- getCompareTable(test, prediction)

## plot the predicted vs actual in test set
library(ggplot2)
library(reshape2)

compare_long <- melt(compare)
g <- ggplot(data = compare_long, aes(x=foodcourt, y = value, colour = variable, group = variable)) + theme_bw()
g <- g + geom_bar(stat = "identity", position = "dodge", aes(fill=variable))
g
