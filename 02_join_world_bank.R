wb = read_csv("world_bank_classifications2024.csv", na = "") %>% 
  mutate(wb = fct_relevel(wb, "High income", "Upper middle income", "Lower middle income")) %>% 
  select(iso2, wb)

n_records0 = n_distinct(hospital_data_orig$record_id)

hospital_data_orig = hospital_data_orig %>% 
  mutate(iso2 = toupper(str_sub(redcap_data_access_group, 1, 2))) %>% 
  left_join(wb) %>% 
  mutate(wb = ff_label(wb, "WB income level"))

n_records1 = n_distinct(hospital_data_orig$record_id)
stopifnot(n_records0 == n_records1)
stopifnot(nrow(drop_na(wb)) == nrow(wb))
