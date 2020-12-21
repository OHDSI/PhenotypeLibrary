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

for (i in (1:length(phenotypes))) {
  cohortDescriptionLocal <- cohortDescription %>%
    dplyr::filter(phenotypeId == phenotypes[[i]]) %>%
    dplyr::select(phenotypeId, webApiCohortId, cohortName, logicDescription, cohortId, referentConceptId, cohortType, PMID) %>%
    dplyr::distinct()
  unlink(file.path(basePath, phenotypes[[i]], "cohortDescription.csv"), force = TRUE, recursive = TRUE)
  readr::write_excel_csv(x = cohortDescriptionLocal, file = file.path(basePath, phenotypes[[i]], "cohortDescription.csv"), na = "")
}
