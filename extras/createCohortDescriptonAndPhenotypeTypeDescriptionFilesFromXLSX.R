phenotypeDescription <- readxl::read_excel(path = "D:\\git\\github\\ohdsi\\PhenotypeLibrary\\extras\\PhenotypeDescription.xlsx") %>%
  dplyr::mutate(phenotypeName = stringr::str_squish(phenotypeName),
                clinicalDescription = stringr::str_squish(clinicalDescription))

readr::write_excel_csv(x = phenotypeDescription, file = "D:\\git\\github\\ohdsi\\PhenotypeLibrary\\extras\\PhenotypeDescription.csv", na = "")

phenotypes <- phenotypeDescription %>%
  dplyr::filter(phenotypeId != 0) %>%
  dplyr::filter(is.na(deprecate)) %>%
  dplyr::pull(phenotypeId) %>%
  unique()
basePath <- "D:\\git\\github\\ohdsi\\PhenotypeLibrary\\inst"


for (i in (1:length(phenotypes))) {
  phenotypeDescriptionLocal <- phenotypeDescription %>%
    dplyr::filter(phenotypeId == phenotypes[[i]]) %>%
    dplyr::select(phenotypeId, phenotypeName, clinicalDescription) %>%
    dplyr::distinct()
  unlink(file.path(basePath, phenotypes[[i]], "phenotypeDescription.csv"), force = TRUE, recursive = TRUE)
  readr::write_excel_csv(x = phenotypeDescriptionLocal, file = file.path(basePath, phenotypes[[i]], "phenotypeDescription.csv"), na = "")
}

cohortDescription <- readr::read_csv(file = "D:\\git\\github\\ohdsi\\PhenotypeLibrary\\extras\\CohortDescription.csv", col_types = readr::cols(), trim_ws = TRUE)

cohortDescription <- cohortDescription %>%
  dplyr::mutate(cohortName = stringr::str_squish(cohortName),
                logicDescription = stringr::str_squish(logicDescription),
                cohortType = stringr::str_squish(cohortType))

readr::write_excel_csv(x = cohortDescription,
                       file = "D:\\git\\github\\ohdsi\\PhenotypeLibrary\\extras\\CohortDescription.csv", na = "")

for (i in (1:length(phenotypes))) {
  cohortDescriptionLocal <- cohortDescription %>%
    dplyr::filter(phenotypeId == phenotypes[[i]]) %>%
    dplyr::select(phenotypeId, webApiCohortId, cohortName, logicDescription, cohortId, referentConceptId, cohortType, PMID) %>%
    dplyr::distinct()
  unlink(file.path(basePath, phenotypes[[i]], "cohortDescription.csv"), force = TRUE, recursive = TRUE)
  readr::write_excel_csv(x = cohortDescriptionLocal, file = file.path(basePath, phenotypes[[i]], "cohortDescription.csv"), na = "")
}
