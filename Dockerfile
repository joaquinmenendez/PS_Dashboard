FROM rocker/tidyverse:latest
COPY . /PS_Dashboard
WORKDIR /PS_Dashboard
EXPOSE 5024
RUN install2.r --error \
    shiny \
    shinydashboard  \
    lubridate
CMD ["Rscript", "starter.R"]
