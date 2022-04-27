#### Preamble ####
# Purpose: Visualization of the data from World Happiness Reports (2020-2021)
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
library(ggplot2)


#### Read in data ####
data <- read.csv("outputs/data/dataset.csv")

#========= Happiness Score by Regions ===========


data%>%
  ggplot(aes(`Happiness Score - 2020`,reorder(`Region`,`Happiness Score - 2020`),fill=`Region`)) +
  geom_boxplot() + theme_classic() + theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank())+
  ggtitle("Happiness Score by Regions (2020)")

data%>%
  ggplot(aes(`Happiness Score - 2021`,reorder(`Region`,`Happiness Score - 2021`),fill=`Region`))+
  geom_boxplot()+theme_classic()+ theme(legend.position = "none",axis.title.x = element_blank(),axis.title.y = element_blank())+
  ggtitle("Happiness Score by Regions (2021)")




#======== Top 20 & bottom 20 happiest countries in 2020 =========

data%>% arrange(desc(`Happiness Score - 2020`)) %>%
  head(20) %>% ggplot(aes(`Happiness Score - 2020`,reorder(Country,`Happiness Score - 2020`),fill=`Region`)) +
  geom_col() + geom_text(aes(label = `Happiness Score - 2020`), position=position_stack(vjust=0.5),color="black",size=3) +
  theme_classic() + theme(axis.title.x = element_blank(),axis.title.y = element_blank()) +
  scale_fill_brewer(palette = "Spectral") + ggtitle("Top 20 Happiest Countries (2020)") 


data %>% arrange(desc(`Happiness Score - 2020`)) %>%
  tail(20) %>% ggplot(aes(`Happiness Score - 2020`,reorder(`Country`,`Happiness Score - 2020`),fill=`Region`)) +
  geom_col() + geom_text(aes(label = `Happiness Score - 2020`), position=position_stack(vjust=0.5),color="black",size=3) +
  theme_classic() + theme(axis.title.x = element_blank(),axis.title.y = element_blank()) +
  scale_fill_brewer(palette = "Spectral") + ggtitle("Bottom 20 Happiest Countries (2020)")


#======== Top 20 & bottom 20 happiest countries in 2021 =========
data %>% arrange(desc(`Happiness Score - 2021`)) %>%
  head(20)%>%ggplot(aes(`Happiness Score - 2021`,reorder(`Country`,`Happiness Score - 2021`),fill=`Region`))+
  geom_col()+ geom_text(aes(label = `Happiness Score - 2021`), position=position_stack(vjust=0.5),color="black",size=3)+
  theme_classic()+theme(axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_fill_brewer(palette = "Spectral")+ggtitle("Top 20 Happiest Countries (2021)")


data %>% arrange(desc(`Happiness Score - 2021`)) %>%
  tail(20)%>%ggplot(aes(`Happiness Score - 2021`,reorder(`Country`,`Happiness Score - 2021`),fill=`Region`))+
  geom_col()+ geom_text(aes(label = `Happiness Score - 2021`), position=position_stack(vjust=0.5),color="black",size=3)+
  theme_classic()+theme(axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_fill_brewer(palette = "Spectral")+ggtitle("Bottom 20 Happiest Countries (2021)")

#========= Effect of GDP per capita on Happiness (2020 & 2021) ==========


data %>% ggplot(aes(`Happiness Score - 2020`, `Logged GDP per capita - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Logged GDP per Capita") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of GDP per Capita on Happiness (2020)") + theme_classic()

data %>% ggplot(aes(`Happiness Score - 2021`, `Logged GDP per capita - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Logged GDP per Capita") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of GDP per Capita on Happiness (2021)") + theme_classic()

#========== Effect of Social Support on Happiness (2020 & 2021) =========

data %>% ggplot(aes(`Happiness Score - 2020`, `Social Support - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Social Support") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Social Support on Happiness (2020)") + theme_classic()

data %>% ggplot(aes(`Happiness Score - 2021`, `Social Support - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Social Support") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of Social Support on Happiness (2021)") + theme_classic()

#=========== Effect of Freedom on Happiness (2020 & 2021) ==========

data %>% ggplot(aes(`Happiness Score - 2020`, `Freedom to make life choices - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Freedom") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Freedom to make life choices on Happiness (2020)") + theme_classic()

data %>% ggplot(aes(`Happiness Score - 2021`, `Freedom to make life choices - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Freedom") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Freedom to make life choices on Happiness (2021)") + theme_classic()

#======== Percentage of countries with increased happiness between 2020 and 2021 ==========

piechartDF <- data %>% select(Country, `Happiness Score - 2020`, `Happiness Score - 2021`) %>%
  mutate(increase_in_2021 = ifelse(`Happiness Score - 2021`>`Happiness Score - 2020`, 'Increased', 'Not Increased')) %>% 
  count(increase_in_2021)

# Compute percentages
piechartDF$fraction <- piechartDF$n / sum(piechartDF$n)

# Compute the cumulative percentages (top of each rectangle)
piechartDF$ymax <- cumsum(piechartDF$fraction)

# Compute the bottom of each rectangle
piechartDF$ymin <- c(0, head(piechartDF$ymax, n=-1))


ggplot(piechartDF, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=increase_in_2021)) +
  geom_rect() +
  geom_text(x = 2, y = 0, label = paste0(round(piechartDF[1,]$fraction*100,0),'%'), size = 22)+
  scale_fill_manual(values = c("#32a854", "#e0e0e0")) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none", plot.title = element_text(vjust = -8)) + labs(title="Percentage of countries with increased happiness between 2020 and 2021")

