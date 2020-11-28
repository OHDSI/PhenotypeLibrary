library(magrittr)
path <- rstudioapi::getActiveProject()
phenotypeFolders <-
  list.files(file.path(path, "inst"),
             pattern = "[0-9]+",
             full.names = TRUE)

# Phenotype descriptions
phenotypeDescription <-
  lapply(
    file.path(phenotypeFolders, "phenotypeDescription.csv"),
    readr::read_csv,
    col_types = readr::cols()
  ) %>%
  dplyr::bind_rows() %>%
  dplyr::arrange(.data$phenotypeId) %>%
  dplyr::distinct()


readr::write_excel_csv(
  x = phenotypeDescription,
  path = file.path(path, "extras", "PhenotypeDescription.csv"),
  na = ""
)

# Cohort descriptions
cohortDescription <-
  lapply(
    file.path(phenotypeFolders, "cohortDescription.csv"),
    readr::read_csv,
    col_types = readr::cols()
  ) %>%
  dplyr::bind_rows() %>%
  dplyr::arrange(.data$phenotypeId, .data$cohortId) %>%
  dplyr::distinct()
readr::write_excel_csv(x = cohortDescription,
                       path = file.path(path, "extras", "CohortDescription.csv"),
                       na = "")
