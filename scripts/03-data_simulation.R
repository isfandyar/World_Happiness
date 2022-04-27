#### Preamble ####
# Purpose: Simulation of the data from World Happiness Reports (2020-2021)
# Author: Isfandyar Virani
# Data: 25 April 2022
# Contact: isfandyar.virani@mail.utoronto.ca
# License: MIT

library("tidyverse")
library("countrycode")
library(dplyr)

set.seed(27042022)

countries <- countrycode::codelist$country.name.en
region <- countrycode::codelist$region
data_simulation <-  tibble(
  Country = rep(c(countries), replace= FALSE),
  Region = rep(c(region), replace=FALSE),
  `Happiness Score - 2020` = runif(length(countries), min=0, max=8),
  `Logged GDP per capita - 2020`= runif(length(countries), min=6, max=12),
  `Social Support - 2020` =   runif(length(countries), min=0, max=1),
  `Healthy Life Expectancy - 2020` =runif(length(countries), min=48, max=77) ,
  `Freedom to make life choices - 2020` =runif(length(countries), min=0, max=1) ,
  `Generosity - 2020`= runif(length(countries), min=-1, max=1),
  `Perceptions of Corruption - 2020` = runif(length(countries), min=0, max=1),
  `Happiness Score - 2021` = runif(length(countries), min=0, max=8),
  `Logged GDP per capita - 2021`= runif(length(countries), min=6, max=12),
  `Social Support - 2021` =   runif(length(countries), min=0, max=1),
  `Healthy Life Expectancy - 2021` =runif(length(countries), min=48, max=77) ,
  `Freedom to make life choices - 2021` =runif(length(countries), min=0, max=1) ,
  `Generosity - 2021`= runif(length(countries), min=-1, max=1),
  `Perceptions of Corruption - 2021` = runif(length(countries), min=0, max=1)
  )


# This is a simulated data created using random sampling that is similar to the main dataset used in the report.
# The weakness of this simulation is that it doesn't capture how different regions perform better, as the simulation is randomized.
# Also, the simulated data is of 288 countries compared to the report having 148 countries of data.