# This code was used to convert ANSI/cp1252 encoded json files to UTF8
library(dplyr)
phenotypeIds <- list.files("inst") %>%
  stringr::str_subset("\\d+")

jsonFiles <- purrr::map(phenotypeIds, ~paste0(glue::glue("inst/{.}/") , list.files(glue::glue("inst/{.}")))) %>%
  unlist() %>%
  stringr::str_subset("\\.json")

# convert all json files to utf8, only do this once.
# for(f in jsonFiles){
#   readr::read_lines_raw(f) %>%
#     purrr::map(stringi::stri_encode, from = "cp1252", to = "UTF8") %>%
#     unlist %>%
#     readr::write_lines(f)
# }
