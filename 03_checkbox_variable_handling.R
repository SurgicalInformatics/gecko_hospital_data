library(tidyverse)
library(scales)
theme_set(theme_bw())
library(finalfit)

labels_keep = extract_variable_label(hospital_data_orig)

checkbox_vars_orig = hospital_data_orig %>% 
  select(record_id, contains("___"))

labels_df = tibble(name = names(labels_keep),
                   label = labels_keep)

checkbox_vars = checkbox_vars_orig %>% 
  pivot_longer(-record_id) %>% 
  filter(value == "Checked") %>%
  left_join(labels_df) %>% 
  # using separate ro remove ___1, ___2, etc: 
  # just because it's easier than regexp
  separate(name, into = c("name", NA), sep = "___") %>% 
  summarise(.by = c(record_id, name),
            values = paste(label, collapse = ", ")) %>% 
  pivot_wider(names_from = name, values_from = values)

# check that record_id remains distinct (so no duplicated created in join)
stopifnot(n_distinct(checkbox_vars$record_id) == nrow(checkbox_vars))

# check that None only appears alone
stopifnot(
  checkbox_vars %>%
    count(train_sim_yn, sort = TRUE) %>%
    filter(str_detect(train_sim_yn, "No")) %>% 
    nrow() == 1)


hospital_data = hospital_data_orig %>% 
  select(-contains("___")) %>% 
  left_join(checkbox_vars)

var_order = labels_df %>% 
  mutate(label = if_else(str_detect(name, "___"), NA, label)) %>% 
  separate(name, into = c("name", NA), sep = "___", fill = "right") %>% 
  distinct()

# check that we've not changed the number and names of variables in this script:
stopifnot(all(var_order$name %in% names(hospital_data)))
stopifnot(all(names(hospital_data) %in% var_order$name))
stopifnot(nrow(var_order) == ncol(hospital_data))


hospital_data = hospital_data %>% 
  select(all_of(var_order$name)) %>% 
  mutate(hosp_mis_type         = ff_label(hosp_mis_type        , "Type of MI equipment"),
         service_cons_type     = ff_label(service_cons_type    , "Specialist surgeons performing cholecystectomies"),
         service_type          = ff_label(service_type         , "Cholecystectomy services"),
         service_setting       = ff_label(service_setting      , "Where are cholecystectomies performed"),
         train_grade           = ff_label(train_grade          , "Trainee gallbladder surgeon grades"),
         train_sim_yn          = ff_label(train_sim_yn         , "Simulation facilities for cholecystectomies"),
         train_sim_type        = ff_label(train_sim_type       , "Types of simulation training available"),
         tain_chole            = ff_label(tain_chole           , "Structured coaching for cholecystectomy training"),
         train_bdi             = ff_label(train_bdi            , "Structured coaching for bile duct injury training")
         )

rm(checkbox_vars_orig, checkbox_vars, labels_df, var_order, labels_keep)
