setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(ggplot2)

subject_colors <- c('1' = 'red', '2' = 'orange', '3' = 'gold', '4' = 'forestgreen', '5' = 'blue', '6' = 'purple')


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
    data$Subject <- as.factor(k)
    
    
    
    totdata[[length(totdata) + 1]] <- data
  }
  expdata <- read.csv("expdata.txt", col.names = c('t','y','Subject'), header=FALSE)
  expdata$t = expdata$t + 1.5
  expdata$Subject <- gsub("Subject ", "", expdata$Subject)
  expdata$Subject <- as.factor(expdata$Subject)
  combined_data <- do.call(rbind, totdata)
  p = ggplot() +
    geom_point(data=expdata, aes(x=t, y=y,color=factor(Subject), shape=Subject), stroke=1) +
    geom_line(data=combined_data, aes(x = t, y = y, color = factor(Subject))) +
    labs(title = paste0("Problem 1",problems[i], ". Caffeine Concentration Over Time"),
         x = "Time (hrs)",
         y = "Concentration (mg/L)",
         color = "Subject") +
    scale_color_manual(values = subject_colors)+
    scale_shape_manual(values = c(1, 2, 3, 4, 5, 6)) +
    scale_y_continuous(limits = c(0, 5.5)) +
    scale_x_continuous(limits = c(0, 14.5))+
    theme_minimal()
  print(p)
  
}



# Combine all the data frames into one



