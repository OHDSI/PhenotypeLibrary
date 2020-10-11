library(magrittr)
path <- rstudioapi::getActiveProject()

# Cohort descriptions
deleteTheseCohorts <- c(133834004)
cohortDescription <- dplyr::bind_rows(readr::read_csv(file = file.path(path, "extras", "CohortDescription.csv"),
                                                      guess_max = min(1e7),
                                                      col_types = readr::cols())) %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId) %>%
  dplyr::distinct() %>%
  dplyr::filter(!cohortId %in% deleteTheseCohorts)
readr::write_excel_csv(cohortDescription, file.path(path, "extras", "CohortDescription.csv"),
                       na = "")


# Phenotype descriptions
deleteThesePhenotypes <- c()
phenotypeDescription <- dplyr::bind_rows(readr::read_csv(file = file.path(path, "extras", "PhenotypeDescription.csv"),
                                                         guess_max = min(1e7),
                                                         col_types = readr::cols())) %>%
                                           dplyr::filter(!i.data$PhenotypeId %in% deleteThesePhenotypes) %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId) %>%
  dplyr::distinct()
readr::write_excel_csv(phenotypeDescription, file.path(path, "extras", "PhenotypeDescription.csv"),
                       na = "")
