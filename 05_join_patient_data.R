library(pins)

# Load patient data
#==================
board = board_connect()
patient_data = pin_read(board, "rots/gecko_patient_data")

# Data sets to join
#==================
# hospital part
df_hospital = hospital_data %>% 
  rename("redcap_data_access_group_orig" = "redcap_data_access_group") %>% 
  rename("redcap_data_access_group" = "data_collection_dag") %>% 
  dplyr::rename("hospital_record_id" = "record_id")

# Patient part
df_patient = patient_data%>% 
  dplyr::rename("patient_record_id" = "record_id") %>% 
  select(-iso2, -wb)


# Perform join
#=============
joined_data = left_join( 
  df_patient,
  
  df_hospital %>% distinct(redcap_data_access_group, .keep_all = T)
)

rm(df_hospital)
rm(df_patient)