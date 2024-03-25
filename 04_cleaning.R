# Cleaning

hospital_data_orig = hospital_data_orig %>% 
  mutate(hosp_itu_bed = parse_number(hosp_itu_bed)) %>% 
  mutate(service_chole_n = parse_number(service_chole_n)) %>%  # note case of "500+"
  mutate(service_cons_n = parse_number(service_cons_n)) %>%  # note case of "100+"
  mutate(service_cons_lap_n = parse_number(service_cons_lap_n)) %>% 
  mutate(service_eme_n = parse_number(service_eme_n))
