#### Preamble ####
# Purpose: Analysis/Modeling of the data from World Happiness Reports (2020-2021)
# Author: Isfandyar Virani
# Data: 25 April 2022
# Contact: isfandyar.virani@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(readxl)
library(stringr)
library(dplyr)
library(modelsummary)


#### Read in data ####
data <- read_excel("outputs/data/dataset.xlsx")
data_2021 <- read_excel("inputs/data/Appendix_2_Data_for_Figure_2.1_2021.xls")
data_2020 <- read_excel("inputs/data/WHR20_DataForFigure2.1_2020.xls")


#========== List of countries that were excluded ======
# These countries were found in 2020 but not in 2021 or vice versa.

ListofcountriesExcluded <- rbind(subset(data_2021,!(`Country name`%in%data_2020$`Country name`)) %>% select(`Country name`), subset(data_2020,!(`Country name`%in%data_2021$`Country name`)) %>% select(`Country name`))
ListofcountriesExcluded

#======= Multiple Linear Regression=========

Model2020 <- lm(`Happiness Score - 2020` ~ `Logged GDP per capita - 2020` + `Social Support - 2020` +
                  `Healthy Life Expectancy - 2020`+`Freedom to make life choices - 2020` + 
                  `Generocity - 2020`+ `Perceptions of Corruption - 2020`,
     data = data)

names(Model2020$coefficients) <- c('(Intercept)','Logged GDP per capita','Social Support','Healthy Life Expectancy', 'Freedom to make life choices', 'Generocity', 'Perceptions of Corruption')

summary(Model2020)


Model2021 <- lm(`Happiness Score - 2021` ~ `Logged GDP per capita - 2021` + `Social Support - 2021` +
                  `Healthy Life Expectancy - 2021`+`Freedom to make life choices - 2021` + 
                  `Generocity - 2021`+ `Perceptions of Corruption - 2021`,
                data = data)
names(Model2021$coefficients) <- c('(Intercept)','Logged GDP per capita','Social Support','Healthy Life Expectancy', 'Freedom to make life choices', 'Generocity', 'Perceptions of Corruption')

summary(Model2021)



modelsummary(list(Model2020,
                  Model2021),
             fmt = 2,
             title = "Explaining happiness of countries from 2020 and 2021 World Hapiness Report Dataset")
