#### Preamble ####
# Purpose: Visualization (Tables & Graphs) of the data from World Happiness Reports (2020-2021)
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
library(vtable)

library(grid)
library(gridExtra)
library(corrplot)

#### Read in data ####
data <- read_excel("outputs/data/dataset.xlsx")

#========= Happiness Score by Regions ===========


data%>%
  ggplot(aes(`Happiness Score - 2020`,reorder(`Region`,`Happiness Score - 2020`),fill=`Region`)) +
  geom_boxplot() + theme_classic() + theme(legend.position = "none", axis.title.x = element_blank(), axis.title.y = element_blank())+
  ggtitle("Happiness Score by Regions (2019)")

data%>%
  ggplot(aes(`Happiness Score - 2021`,reorder(`Region`,`Happiness Score - 2021`),fill=`Region`))+
  geom_boxplot()+theme_classic()+ theme(legend.position = "none",axis.title.x = element_blank(),axis.title.y = element_blank())+
  ggtitle("Happiness Score by Regions (2020)")


#=======================Differences between Happiness Scores in 2019 & 2020 by Region===========================


data %>% select(Region, `Happiness Score - 2020`, `Happiness Score - 2021`) %>% group_by(Region) %>%
  summarise('Mean Happiness Score of 2019' = mean(`Happiness Score - 2020`), 
            'Mean Happiness Score of 2020' = mean(`Happiness Score - 2021`),
            'Difference between Happiness Score' = mean(`Happiness Score - 2021`) - mean(`Happiness Score - 2020`)) %>% 
  arrange(desc(`Difference between Happiness Score`))
  

#======== Top 20 & bottom 20 happiest countries in 2020 =========

data%>% arrange(desc(`Happiness Score - 2020`)) %>%
  head(20) %>% ggplot(aes(`Happiness Score - 2020`,reorder(Country,`Happiness Score - 2020`),fill=`Region`)) +
  geom_col() + geom_text(aes(label = `Happiness Score - 2020`), position=position_stack(vjust=0.5),color="black",size=3) +
  theme_classic() + theme(axis.title.x = element_blank(),axis.title.y = element_blank()) +
  scale_fill_brewer(palette = "Spectral") + ggtitle("Top 20 Happiest Countries (2019)") 


data %>% arrange(desc(`Happiness Score - 2020`)) %>%
  tail(20) %>% ggplot(aes(`Happiness Score - 2020`,reorder(`Country`,`Happiness Score - 2020`),fill=`Region`)) +
  geom_col() + geom_text(aes(label = `Happiness Score - 2020`), position=position_stack(vjust=0.5),color="black",size=3) +
  theme_classic() + theme(axis.title.x = element_blank(),axis.title.y = element_blank()) +
  scale_fill_brewer(palette = "Spectral") + ggtitle("Bottom 20 Happiest Countries (2019)")


#======== Top 20 & bottom 20 happiest countries in 2021 =========
data %>% arrange(desc(`Happiness Score - 2021`)) %>%
  head(20)%>%ggplot(aes(`Happiness Score - 2021`,reorder(`Country`,`Happiness Score - 2021`),fill=`Region`))+
  geom_col()+ geom_text(aes(label = `Happiness Score - 2021`), position=position_stack(vjust=0.5),color="black",size=3)+
  theme_classic()+theme(axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_fill_brewer(palette = "Spectral")+ggtitle("Top 20 Happiest Countries (2020)")


data %>% arrange(desc(`Happiness Score - 2021`)) %>%
  tail(20)%>%ggplot(aes(`Happiness Score - 2021`,reorder(`Country`,`Happiness Score - 2021`),fill=`Region`))+
  geom_col()+ geom_text(aes(label = `Happiness Score - 2021`), position=position_stack(vjust=0.5),color="black",size=3)+
  theme_classic()+theme(axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_fill_brewer(palette = "Spectral")+ggtitle("Bottom 20 Happiest Countries (2020)")


#======== Percentage of countries with increased happiness between 2020 and 2021 ==========
#### Got inspiration of code from https://r-graph-gallery.com/128-ring-or-donut-plot.html
piechartDF <- data %>% select(Country, `Happiness Score - 2020`, `Happiness Score - 2021`) %>%
  mutate(increase_in_2021 = ifelse(`Happiness Score - 2021`>`Happiness Score - 2020`, 'Increased', 'Not Increased'))%>% dplyr::count(increase_in_2021)

 

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
  theme(legend.position = "none", plot.title = element_text(vjust = -8)) + labs(title="Percentage of countries with increased happiness between 2019 and 2020")
#========= World Map for Happiness - 2020 =======

mapdata <- data %>% select(Country, `Happiness Score - 2020`, `Happiness Score - 2021`)
jcm <- joinCountryData2Map(mapdata, joinCode="NAME", nameJoinColumn="Country")
mapCountryData(jcm, nameColumnToPlot='Happiness Score - 2020', mapTitle="World Map for Happiness - 2019",colourPalette="negpos8")

#========= World Map for Happiness - 2021 =======

mapCountryData(jcm, nameColumnToPlot='Happiness Score - 2021', mapTitle="World Map for Happiness - 2020",colourPalette="negpos8")

#========================= World Happiness Report Summary Statistics =========================


data %>% mutate('Happiness Score' = `Happiness Score - 2020`, 
                  'Logged GDP per capita' = `Logged GDP per capita - 2020`, 
                  'Social Support' = `Social Support - 2020`, 
                  'Healthy Life Expectancy' = `Healthy Life Expectancy - 2020`,
                  'Freedom to make life choices' = `Freedom to make life choices - 2020`, 
                  'Generosity' = `Generosity - 2020`,
                  'Perceptions of Corruption' = `Perceptions of Corruption - 2020`) %>%
  select(`Happiness Score`,`Logged GDP per capita`, `Social Support` , `Healthy Life Expectancy`,
         `Freedom to make life choices`, `Generosity`, `Perceptions of Corruption`) %>%
  sumtable(title = 'World Happiness Report Summary Statistics - 2019')

data %>% mutate('Happiness Score' = `Happiness Score - 2021`, 
                'Logged GDP per capita' = `Logged GDP per capita - 2021`, 
                'Social Support' = `Social Support - 2021`, 
                'Healthy Life Expectancy' = `Healthy Life Expectancy - 2021`,
                'Freedom to make life choices' = `Freedom to make life choices - 2021`, 
                'Generosity' = `Generosity - 2021`,
                'Perceptions of Corruption' = `Perceptions of Corruption - 2021`) %>%
  select(`Happiness Score`,`Logged GDP per capita`, `Social Support` , `Healthy Life Expectancy`,
         `Freedom to make life choices`, `Generosity`, `Perceptions of Corruption`) %>%
  sumtable(title = 'World Happiness Report Summary Statistics - 2020')


#===================================================


#========= Effect of GDP per capita on Happiness (2020 & 2021) ==========


graphGDP2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Logged GDP per capita - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Logged GDP per Capita") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of GDP per Capita on Happiness (2019)") + theme_classic()

graphGDP2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Logged GDP per capita - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Logged GDP per Capita") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of GDP per Capita on Happiness (2020)") + theme_classic()

#========== Effect of Social Support on Happiness (2020 & 2021) =========

graphSocialSupport2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Social Support - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Social Support") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Social Support on Happiness (2019)") + theme_classic()

graphSocialSupport2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Social Support - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Social Support") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of Social Support on Happiness (2020)") + theme_classic()

#=========== Effect of Freedom on Happiness (2020 & 2021) ==========

graphFreedom2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Freedom to make life choices - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Freedom") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Freedom to make life choices on Happiness (2019)") + theme_classic()

graphFreedom2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Freedom to make life choices - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Freedom") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Freedom to make life choices on Happiness (2020)") + theme_classic()


#========== Effect of Healthy life expectancy on Happiness (2020 & 2021) =========

graphHealth2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Healthy Life Expectancy - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Healthy life expectancy") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Healthy life expectancy on Happiness (2019)") + theme_classic()

graphHealth2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Healthy Life Expectancy - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Healthy life expectancy") +
  scale_color_brewer(palette = "Spectral")+ggtitle("Effect of Healthy life expectancy on Happiness (2020)") + theme_classic()

#=========== Effect of Generosity on Happiness (2020 & 2021) ==========

graphGenerosity2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Generosity - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Generosity") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Generosity on Happiness (2019)") + theme_classic()

graphGenerosity2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Generosity - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Generosity") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Generosity on Happiness (2020)") + theme_classic()

#=========== Effect of Perceptions of Corruption on Happiness (2020 & 2021) ==========

graphCorruption2020 <- data %>% ggplot(aes(`Happiness Score - 2020`, `Perceptions of Corruption - 2020`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Perceptions of Corruption") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Perceptions of Corruption on Happiness (2019)") + theme_classic()

graphCorruption2021 <- data %>% ggplot(aes(`Happiness Score - 2021`, `Perceptions of Corruption - 2021`)) + geom_point(aes(color=`Region`), size = 3) + xlab("Happiness Score") + ylab("Perceptions of Corruption") +
  scale_color_brewer(palette="Spectral")+ggtitle("Effect of Perceptions of Corruption on Happiness (2020)") + theme_classic()


#=============== Grid Graphs ==================

grid.arrange(graphGDP2020, graphGDP2021, graphSocialSupport2020, graphSocialSupport2021, ncol=2, nrow =2)
grid.arrange(graphFreedom2020,graphFreedom2021,graphHealth2020,graphHealth2021, ncol=2, nrow =2)
grid.arrange(graphGenerosity2020,graphGenerosity2021,graphCorruption2020,graphCorruption2020, ncol=2, nrow =2)


#grid.arrange(graphGDP2020, graphGDP2021, graphSocialSupport2020, graphSocialSupport2021, 
#             graphFreedom2020,graphFreedom2021,graphHealth2020,graphHealth2021,
#             graphGenerosity2020,graphGenerosity2021,graphCorruption2020,graphCorruption2020,
#             ncol=2, nrow =6)


#=================== Correlation ===============================


cor(data %>% mutate('Happiness Score' = `Happiness Score - 2020`, 
                'Logged GDP per capita' = `Logged GDP per capita - 2020`, 
                'Social Support' = `Social Support - 2020`, 
                'Healthy Life Expectancy' = `Healthy Life Expectancy - 2020`,
                'Freedom to make life choices' = `Freedom to make life choices - 2020`, 
                'Generosity' = `Generosity - 2020`,
                'Perceptions of Corruption' = `Perceptions of Corruption - 2020`) %>%
  select(`Happiness Score`,`Logged GDP per capita`, `Social Support` , `Healthy Life Expectancy`,
         `Freedom to make life choices`, `Generosity`, `Perceptions of Corruption`)) %>%
  corrplot(method = 'number', type="upper", tl.cex = .7, tl.col = 'black' ,
           cl.ratio = 0.2, tl.srt = 20, col = colorRampPalette(c("darkorange", "white", "steelblue"))(20))
mtext("Correlation Plot - Year 2019", at=1, line=-20, cex=2)


cor(data %>% mutate('Happiness Score' = `Happiness Score - 2021`, 
                    'Logged GDP per capita' = `Logged GDP per capita - 2021`, 
                    'Social Support' = `Social Support - 2021`, 
                    'Healthy Life Expectancy' = `Healthy Life Expectancy - 2021`,
                    'Freedom to make life choices' = `Freedom to make life choices - 2021`, 
                    'Generosity' = `Generosity - 2021`,
                    'Perceptions of Corruption' = `Perceptions of Corruption - 2021`) %>%
      select(`Happiness Score`,`Logged GDP per capita`, `Social Support` , `Healthy Life Expectancy`,
             `Freedom to make life choices`, `Generosity`, `Perceptions of Corruption`)) %>%
  corrplot(method = 'number', type="upper", tl.cex = .7, tl.col = 'black' ,
           cl.ratio = 0.2, tl.srt = 20, col = colorRampPalette(c("darkorange", "white", "steelblue"))(20))
mtext("Correlation Plot - Year 2020", at=1, line=-20, cex=2)



