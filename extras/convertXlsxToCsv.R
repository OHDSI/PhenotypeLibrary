library(magrittr)
path <- rstudioapi::getActiveProject()

phenotypeDescription <-
  readxl::read_excel(path = file.path(path, "extras", "PhenotypeDescription.xlsx")) %>%
  dplyr::arrange(phenotypeId) %>%
  dplyr::mutate(clinicalDescription = stringr::str_squish(clinicalDescription))

readr::write_excel_csv(
  x = phenotypeDescription ,
  file =  file.path(path, "extras", "PhenotypeDescription.csv"),
  na = ""
)



cohortDescription <-
  readxl::read_excel(path = file.path(path, "extras", "CohortDescription.xlsx")) %>%
  dplyr::mutate(logicDescription = stringr::str_squish(logicDescription),
                cohortName = stringr::str_squish(cohortName)) %>%
  dplyr::arrange(cohortId)

readr::write_excel_csv(
  x = cohortDescription,
  file =  file.path(path, "extras", "CohortDescription.csv"),
  na = ""
)
#
#
# deprecatedList <- phenotypeDescription %>%
#   dplyr::filter(!is.na(deprecate)) %>%
#   dplyr::select(newPhenotypeId, oldPhenotypeId)
#
#
# cohortDescription %>%
#   dplyr::filter(phenotypeId %in% deprecatedList$oldPhenotypeId) %>%
#   View()

