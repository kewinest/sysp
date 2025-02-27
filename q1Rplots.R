setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(ggplot2)



problems = c('b','c','e','f')
for(i in 1:4){
  totdata <- list()
  for(k in 1:6) {
    data <- read.csv(
      paste0('problem',problems[i],'_subject',k,'.txt'),
      col.names=c('t','y'),
      header=FALSE
    )
    data$Problem <- problems[i]
    data$Subject <- k
    
    
    
    totdata[[length(totdata) + 1]] <- data
  }
  expdata <- read.csv("expdata.txt", col.names = c('t','y','Subject'), header=FALSE)
  expdata$t = expdata$t + 1.5
  combined_data <- do.call(rbind, totdata)
  p = ggplot() +
    geom_point(data=expdata, aes(x=t, y=y,color=factor(Subject))) +
    geom_line(data=combined_data, aes(x = t, y = y, color = factor(Subject))) +
    labs(title = paste0("Problem 1",problems[i], ". Caffeine Concentration Over Time"),
         x = "Time (hrs)",
         y = "Concentration (mg/L)",
         color = "Subject") +
    theme_minimal()
  print(p)
  
}



# Combine all the data frames into one



