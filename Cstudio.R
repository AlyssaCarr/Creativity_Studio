install.packages("qualtRics")

library(qualtRics)
library(tidyverse)
library(janitor)
library(skimr)
library(dplyr)
library(gt)

qualtrics_api_credentials(api_key = "cKKLgSZ3FAmIUCD15UM18ifMNYIkWAGIB9IYG6lt",
                          base_url = "sjc1.qualtrics.com",
                          install = TRUE)

surveys <- all_surveys()   

cstudio <- fetch_survey(surveyID = surveys$id[2],
                        verbose = TRUE)
                          
cstudio <- cstudio %>% 
  clean_names() %>% 
  pivot_longer(cols = q1_41:q1_53,
               names_to = "why_visit",
               values_to = "offering") 

cstudio <- cstudio %>% 
  pivot_longer(cols = q20_37:q20_50,
               names_to = "how_hear",
               values_to = "hear")

cstudio <- cstudio %>% 
  pivot_longer(cols = q28_38:q28_25,
               names_to = "what_do",
               values_to = "do")

cstudio <- cstudio %>% 
  pivot_longer(cols = q22_1:q22_6,
               names_to = "agree_disagree",
               values_to = "agree")

cstudio <- cstudio %>% 
  pivot_longer(cols = q8_1:q8_7,
               names_to = "race_ethnicity",
               values_to = "race")

cstudio <- cstudio %>%  
  pivot_longer(cols = q10_1:q10_7,
               names_to = "visit_group",
               values_to = "group")

cstudio <- cstudio %>% 
  pivot_longer(cols = q29_1:q29_24,
               names_to = "language",
               values_to = "lang")

