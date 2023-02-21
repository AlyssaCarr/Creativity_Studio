install.packages("qualtRics")

library(qualtRics)
library(tidyverse)
library(janitor)
library(skimr)
library(dplyr)
library(gt)
library(readxl)

cs <- read_excel("data_raw/creativity_studio.xlsx")



qualtrics_api_credentials(api_key = "cKKLgSZ3FAmIUCD15UM18ifMNYIkWAGIB9IYG6lt",
                          base_url = "sjc1.qualtrics.com",
                          install = TRUE)

surveys <- all_surveys()   

cstudio2 <- fetch_survey(surveyID = surveys$id[2],
                        verbose = TRUE)

cstudio2 <- cstudio2 %>% 
  clean_names()

why_visit <- cstudio2 %>% 
  pivot_longer(cols = q1_41:q1_53,
               names_to = "why_visit",
               values_to = "offering") %>% 
  mutate(offering = replace_na(offering, "No"))%>% 
  select(response_id, why_visit, offering) %>% 
  na_if("No") %>% 
  drop_na()

how_hear <- cstudio2 %>% 
  pivot_longer(cols = q20_37:q20_50,
               names_to = "how_hear",
               values_to = "hear") %>% 
  mutate(hear = replace_na(hear, "No"))%>% 
  select(response_id, how_hear, hear) %>% 
  na_if("No") %>% 
  drop_na()

what_do <- cstudio2 %>% 
  pivot_longer(cols = q28_38:q28_25,
               names_to = "what_do",
               values_to = "do") %>% 
  select(response_id, what_do, do) %>% 
  drop_na()

agree_disagree <- cstudio2 %>% 
  pivot_longer(cols = q22_1:q22_6,
               names_to = "agree_disagree",
               values_to = "agree") %>% 
  select(response_id, agree_disagree, agree) %>% 
  drop_na()

cs_race <- cstudio2 %>% 
  pivot_longer(cols = q8_1:q8_7,
               names_to = "race_ethnicity",
               values_to = "race") %>% 
  select(response_id, race_ethnicity, race) %>% 
  drop_na()

visit_group <- cstudio2 %>%  
  pivot_longer(cols = q10_1:q10_7,
               names_to = "visit_group",
               values_to = "group") %>% 
  select(response_id, visit_group, group) %>% 
  drop_na()

cstudio2 <- cstudio2 %>% 
  select(-c("start_date":"recorded_date"),
         -c("recipient_last_name":"user_language"),
         -c("q1_41":"q1_53_text"),
         -c("q20_37":"q20_50"),
         -c("q28_38":"q28_25"),
         -c("q22_1":"q22_6"),
         -c("q8_1":"q8_7"),
         -c("q10_1":"q10_7"),
         -c("q29_1":"q29_24"))

cstudio2 <- cstudio2 %>% 
  select (-"q20_50_text") %>% 
  select(-"q8_7_text")

cstudio2 <- cstudio2 %>% 
  select (-"q10_7_text") %>% 
  select(-"q29_24_text")

creativity <- left_join(cstudio2,
                        agree_disagree,
                        by = "response_id")

creativity <- left_join(creativity,
                        cs_race,
                        by = "response_id")

creativity <- left_join(creativity,
                        how_hear,
                        by = "response_id")

creativity <- left_join(creativity,
                        visit_group,
                        by = "response_id")

creativity <- left_join(creativity,
                        what_do,
                        by = "response_id")

creativity <- left_join(creativity,
                        why_visit,
                        by = "response_id")

write_rds(creativity,
          file = "data/creativity.rds")

