# install.packages(c("sys","shinydashboard" ,"forcats","stringr","dplyr",
#                   "purrr","readr","tidyr","tibble","ggplot2","tidyverse",
#                   "lubridate","shiny"),
#                 dependencies=TRUE,
#                 repos='http://cran.rstudio.com/')

library(shiny)
shiny::runApp('./', port = 5024, host="0.0.0.0")
 
