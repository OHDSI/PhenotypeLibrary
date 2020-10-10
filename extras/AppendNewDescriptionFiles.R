library(magrittr)
path <- rstudioapi::getActiveProject()

# Cohort descriptions
cohortDescription <- dplyr::bind_rows(readr::read_csv(file = file.path(path, "extras", "CohortDescription.csv"),
                                                      guess_max = min(1e7),
                                                      col_types = readr::cols()),
                                      readr::read_csv(file = file.path(path, "extras", "NewCohorts.csv"),
                                                      guess_max = min(1e7),
                                                      col_types = readr::cols())) %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId) %>%
  dplyr::distinct()
readr::write_excel_csv(cohortDescription, file.path(path, "extras", "CohortDescription.csv"),
                       na = "")


# Phenotype descriptions
phenotypeDescription <- dplyr::bind_rows(readr::read_csv(file = file.path(path, "extras", "PhenotypeDescription.csv"),
                                                         guess_max = min(1e7),
                                                         col_types = readr::cols()),
                                         readr::read_csv(file = file.path(path, "extras", "NewPhenotypeDescription.csv"),
                                                         guess_max = min(1e7),
                                                         col_types = readr::cols()) %>%
                                           dplyr::filter(!is.na(.data$PhenotypeId))) %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId) %>%
  dplyr::distinct()
readr::write_excel_csv(phenotypeDescription, file.path(path, "extras", "PhenotypeDescription.csv"),
                       na = "")
