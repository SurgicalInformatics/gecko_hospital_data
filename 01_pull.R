# Pull redcap team registraion

library(tidyverse)

#pull data
hospital_data_orig <- list("token"=Sys.getenv("redcap_token"),
                           content='record',
                           action='export',
                           format='csv',
                           type='flat',
                           csvDelimiter='',
                           rawOrLabel='raw',
                           rawOrLabelHeaders='raw',
                           exportCheckboxLabel='true',
                           exportSurveyFields='false',
                           exportDataAccessGroups='true',
                           returnFormat='json',
                           'forms[0]'='site_survey',
                           'fields[0]'='data_collection_dag',
                           'fields[1]'='record_id') %>% 
  httr::POST(Sys.getenv("redcap_uri"), body = ., encode = "form") %>% 
  httr::content()



#apply factoring script
data = hospital_data_orig
source("GECKOTeamRegistratio-SiteSurveyDataNeil_R_2024-03-25_1128.r")
hospital_data_orig = data
rm(data)
