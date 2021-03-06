library(shiny)
library(leaflet)
library(dplyr)
library(readxl)
library(rworldmap)
library(readr)
#### Read in data ####

data<- read_csv('https://raw.githubusercontent.com/isfandyar/happinessReport/main/outputs/data/dataset.csv')


######################
ui <- fluidPage(
    titlePanel("World Happiness Report Data Visualized"),
    
    actionButton("year2020", "Year 2019"),
    actionButton("year2021", "Year 2020"),
    hr(),
    leafletOutput("mymap"))

jcm <- joinCountryData2Map(data, joinCode="NAME", nameJoinColumn="Country")


################# Interactive Plot ########################
# Code from https://rstudio.github.io/leaflet/choropleths.html

# Hosted on https://isfandyar-virani.shinyapps.io/happinessreportmap/


mybins <- c(2.5,4.5,5,5.5,6.5,8)
mypalette2020 <- colorBin( palette="YlOrBr", domain=jcm@data[["Happiness Score - 2020"]], na.color="transparent", bins=mybins)
mypalette2021 <- colorBin( palette="YlOrBr", domain=jcm@data[["Happiness Score - 2021"]], na.color="transparent", bins=mybins)

# Prepare the text for tooltips:
mytextYear2020 <- paste(
    "<b>Country: ",jcm@data[["Country"]],"</b><br/>",
    "Year: 2020<br/>",
    "<small>Region: ",jcm@data[["Region"]],"<br/>",
    "Happiness Score: ", round(jcm@data[["Happiness Score - 2020"]], 2), "<br/>",
    "Logged GDP per Capita: ",jcm@data[["Logged GDP per capita - 2020"]],"<br/>",
    "Social Support: ",jcm@data[["Social Support - 2020"]],"<br/>",
    "Healthy Life Expectancy: ",jcm@data[["Healthy Life Expectancy - 2020"]],"<br/>",
    "Freedom to make life choices: ",jcm@data[["Freedom to make life choices - 2020"]],"<br/>",
    "Generosity: ",jcm@data[["Generosity - 2020"]],"<br/>",
    "Perceptions of Corruption: ",jcm@data[["Perceptions of Corruption - 2020"]],"<small/>",
    sep="") %>%
    lapply(htmltools::HTML)


mytextYear2021 <- paste(
    "<b>Country: ",jcm@data[["Country"]],"</b><br/>",
    "Year: 2021<br/>",
    "<small>Region: ",jcm@data[["Region"]],"<br/>",
    "Happiness Score: ", round(jcm@data[["Happiness Score - 2021"]], 2), "<br/>",
    "Logged GDP per Capita: ",jcm@data[["Logged GDP per capita - 2021"]],"<br/>",
    "Social Support: ",jcm@data[["Social Support - 2021"]],"<br/>",
    "Healthy Life Expectancy: ",jcm@data[["Healthy Life Expectancy - 2021"]],"<br/>",
    "Freedom to make life choices: ",jcm@data[["Freedom to make life choices - 2021"]],"<br/>",
    "Generosity: ",jcm@data[["Generosity - 2021"]],"<br/>",
    "Perceptions of Corruption: ",jcm@data[["Perceptions of Corruption - 2021"]],"<small/>",
    sep="") %>%
    lapply(htmltools::HTML)


server <- function(input, output, session) {
    
    observeEvent(input$year2020,{
    output$mymap <- renderLeaflet({
        # Final Map
        leaflet(jcm) %>% 
            addTiles()  %>% 
            setView( lat=10, lng=0 , zoom=2) %>%
            addPolygons( 
                fillColor = ~mypalette2020(`Happiness Score - 2020`), 
                stroke=TRUE, 
                fillOpacity = 0.9, 
                color="white", 
                weight=0.3,
                label = mytextYear2020,
                labelOptions = labelOptions( 
                    style = list("font-weight" = "normal", padding = "3px 8px"), 
                    textsize = "13px", 
                    direction = "auto"
                )
            ) %>%
            addLegend( pal=mypalette2020, values=~`Happiness Score - 2020`, opacity=0.9, title = "Happiness", position = "bottomleft" )
        
        
        
        
    })})
    
    
    observeEvent(input$year2021,{
        output$mymap <- renderLeaflet({
            # Final Map
            leaflet(jcm) %>% 
                addTiles()  %>% 
                setView( lat=10, lng=0 , zoom=2) %>%
                addPolygons( 
                    fillColor = ~mypalette2021(`Happiness Score - 2021`), 
                    stroke=TRUE, 
                    fillOpacity = 0.9, 
                    color="white", 
                    weight=0.3,
                    label = mytextYear2021,
                    labelOptions = labelOptions( 
                        style = list("font-weight" = "normal", padding = "3px 8px"), 
                        textsize = "13px", 
                        direction = "auto"
                    )
                ) %>%
                addLegend( pal=mypalette2021, values=~`Happiness Score - 2021`, opacity=0.9, title = "Happiness", position = "bottomleft" )
            
            
            
            
        })}
    
)}




shinyApp(ui, server)



