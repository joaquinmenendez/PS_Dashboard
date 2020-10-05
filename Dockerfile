FROM r-base
COPY . /home/joaquin/Desktop/Projects/PS_Dashboard
WORKDIR /home/joaquin/Desktop/Projects/PS_Dashboard
EXPOSE 8080
USER root
CMD ["Rscript", "starter.r"]