library(dplyr)
library(stringr)
library(DT)
library(janitor)
library(dqshiny)
library(readxl)


# Read and parse table
taxtable <- read_xlsx("data/2019_12_13.xlsx") %>% 
  remove_empty("cols") 

taxtable_intern <- taxtable %>% 
  mutate(basonym = str_c(taxtable$Genus, taxtable$Species, sep = " ")) %>% 
  mutate(new_name = str_c(taxtable$`proposed new genus name`, taxtable$`proposed new species name`, sep = " "))
