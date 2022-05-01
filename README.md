# Which countries are happier during the COVID-19 pandemic? Are western countries happier compared to developing countries? 

- Author: Isfandyar Virani
- Date: April 27, 2022
- E-mail: isfandyar.virani@mail.utoronto.ca

## Overview of the paper

This repository explores the World Happiness Report data to better understand factors that contribute towards happiness.

## Obtaining data

The data is available on https://worldhappiness.report/archive/

- World Happiness Report 2020 -> APPENDICES & DATA -> Data for Figure 2.1
- World Happiness Report 2021 -> APPENDICES & DATA -> Data for Figure 2.1

It is also included in this repository, in the directory "inputs/data/Appendix_2_Data_for_Figure_2.1_2021.xls" & "inputs/data/WHR20_DataForFigure2.1_2020.xls"

## Preprocess data

After obtaining the xls data spreadsheets on World Happiness, the script "01-data_preparation.R", located in "scripts/01-data_preparation.R", can be used to preprocess the data and save the file as a csv file in the directory "outputs/data/dataset.xlsx" & "outputs/data/dataset.csv" 

## Reproducing Graphs, Tables, and Models

In the script "02-data_visualization.R" and "04-data_analysis_and_modeling.R", located in "scripts/02-data_visualization.R" & "scripts/04-data_analysis_and_modeling.R", contains all the code that is necessary to reproduce the graphs, tables, and models shown in the paper. 

This script uses the file that is located in the path "outputs/data/dataset.csv".

## Building the Report

There is a RMarkDown document located in "outputs/paper/paper.Rmd". This file is used to produce the report "Which countries are happier during the COVID-19 pandemic? Are western countries happier compared to developing countries?". It contains the R code to produce the graphs and the report format code. The reference used are also located in "outputs/paper/references.bib".

## Shiny App

Their is an interactive shiny application which can be found on https://isfandyar-virani.shinyapps.io/happinessreportmap/
The code for the Shiny app can be found in the path "/shiny/HappinessReportMap/app.R"

## Simulated Data

Their is a simulated data script "03-data_simulation.R", located in "scripts/03-data_simulation.R"

## File Structure

1. Inputs
- In this folder, you will find raw data from World Happiness Report 2020 & 2021.

2. Outputs
- In this folder you will find a reference file, RMarkdown file, and a pdf document of the paper, as well as cleaned dataset.

3. Scripts
- This folder contains R-Scripts to run simulation, retrieve, clean, visualization, analysis, and modelling of the dataset.

4. Licence
- Typical MIT licence for re usability



