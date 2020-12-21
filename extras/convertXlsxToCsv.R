library(magrittr)
path <- rstudioapi::getActiveProject()

phenotypeDescription <-
  readxl::read_excel(path = file.path(path, "extras", "PhenotypeDescription.xlsx"))

readr::write_excel_csv(
  x = phenotypeDescription ,
  file =  file.path(path, "extras", "PhenotypeDescription.csv"),
  na = ""
)



cohortDescription <-
  readxl::read_excel(path = file.path(path, "extras", "CohortDescription.xlsx"))

readr::write_excel_csv(
  x = cohortDescription,
  file =  file.path(path, "extras", "CohortDescription.csv"),
  na = ""
)
