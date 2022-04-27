#### Preamble ####
# Purpose: Prepare the World Happiness Report data from 2020-2021
# Author: Isfandyar Virani
# Data: 25 April 2022
# Contact: isfandyar.virani@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(haven)
library(tidyverse)
library(readxl)
library(stringr)
library(dplyr)
# Read in the raw data.

data_2021 <- read_excel("inputs/data/Appendix_2_Data_for_Figure_2.1_2021.xls")
data_2020 <- read_excel("inputs/data/WHR20_DataForFigure2.1_2020.xls")

# Merge Datasets (2020 & 2021)
data <- merge(data_2020 %>% select(`Country name`, `Regional indicator`, 
                                   `Ladder score`, `Logged GDP per capita`, 
                                   `Social support`, `Healthy life expectancy`, 
                                   `Freedom to make life choices`,
                                   Generosity, `Perceptions of corruption`) ,
              data_2021 %>% select(`Country name`, `Regional indicator`, 
                                   `Ladder score`, `Logged GDP per capita`,
                                   `Social support`, `Healthy life expectancy`, 
                                   `Freedom to make life choices`,
                                   Generosity, `Perceptions of corruption`)
              ,by='Country name')

#Remove duplicate Region
data <- within(data, rm(`Regional indicator.y`))

#Rename columns
names(data) <- c('Country',
                 'Region',
                 'Happiness Score - 2020',
                 'Logged GDP per capita - 2020',
                 'Social Support - 2020',
                 'Healthy Life Expectancy - 2020',
                 'Freedom to make life choices - 2020',
                 'Generocity - 2020',
                 'Perceptions of Corruption - 2020',
                 'Happiness Score - 2021',
                 'Logged GDP per capita - 2021',
                 'Social Support - 2021',
                 'Healthy Life Expectancy - 2021',
                 'Freedom to make life choices - 2021',
                 'Generocity - 2021',
                 'Perceptions of Corruption - 2021'
                 )


#Save data in a new file
write_csv(data, "outputs/data/dataset.csv")



