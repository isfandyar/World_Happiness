#### Preamble ####
# Purpose: InteractivePlot of the data from World Happiness Reports (2020-2021)
# Author: Isfandyar Virani
# Data: 25 April 2022
# Contact: isfandyar.virani@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(readxl)
library(dplyr)
library(ggplot2)
library(rworldmap)
library(leaflet)

#### Read in data ####
data <- read_excel("outputs/data/dataset.xlsx")

mapdata <- data %>% select(Country, `Happiness Score - 2020`, `Happiness Score - 2021`)
jcm <- joinCountryData2Map(mapdata, joinCode="NAME", nameJoinColumn="Country")
mapCountryData(jcm, nameColumnToPlot='Happiness Score - 2020', mapTitle="World Map for Happiness - 2020",colourPalette="negpos8")


################# Interactive Plot ########################
# Code from https://rstudio.github.io/leaflet/choropleths.html

mybins <- c(2.5,4.5,5,5.5,6.5,8)
mypalette <- colorBin( palette="YlOrBr", domain=jcm@data[["Happiness Score - 2020"]], na.color="transparent", bins=mybins)
colorBin(heat)
# Prepare the text for tooltips:
mytext <- paste(
  "Country: ",jcm@data[["Country"]],"<br/>",
  "Happiness Score: ", round(jcm@data[["Happiness Score - 2020"]], 2), 
  sep="") %>%
  lapply(htmltools::HTML)

# Final Map
leaflet(jcm) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(`Happiness Score - 2020`), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white", 
    weight=0.3,
    label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~`Happiness Score - 2020`, opacity=0.9, title = "Happiness", position = "bottomleft" )

