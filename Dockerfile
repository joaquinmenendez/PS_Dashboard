FROM rocker/tidyverse:latest

COPY . /home/joaquin/Desktop/Projects/PS_Dashboard
WORKDIR /home/joaquin/Desktop/Projects/PS_Dashboard
EXPOSE 5024
USER root
RUN install2.r --error \
    shiny \
    shinydashboard  \
    forcats \
    stringr \
    dplyr \
    purrr \
    readr \
    tidyr \
    tibble \
    ggplot2 \
    lubridate
RUN R -e "shiny::runApp('./', port=5024, host='0.0.0.0')"
