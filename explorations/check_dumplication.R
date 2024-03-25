# Examine for duplication before joining
#=======================================

# hospital part
df_hospital = hospital_data %>% 
  rename("redcap_data_access_group_orig" = "redcap_data_access_group") %>% 
  rename("redcap_data_access_group" = "data_collection_dag") %>% 
  dplyr::rename("hospital_record_id" = "record_id")

# Patient part
df_patient = patient_data%>% 
  dplyr::rename("patient_record_id" = "record_id") %>% 
  select(-iso2, -wb)

# How many hospital data rows are missing the dag?

missing_hospital_dag = df_hospital %>% 
  select(redcap_data_access_group) %>% 
  mutate(dag_na = is.na(redcap_data_access_group)) %>% 
  count(dag_na)

missing_patient_dag = df_patient %>% 
  select(redcap_data_access_group) %>% 
  mutate(dag_na = is.na(redcap_data_access_group)) %>% 
  count(dag_na)

# Cases of duplicated dag in the hospital data

duplicated_dag_hospital = df_hospital %>% 
  drop_na(redcap_data_access_group) %>% 
  group_by(redcap_data_access_group) %>% 
  mutate(ndag = n()) %>% 
  filter(ndag>1) %>% 
  ungroup() %>% 
  arrange(redcap_data_access_group) %>% 
  relocate(redcap_data_access_group)

rm(df_hospital)
rm(df_patient)