# @file PackageMaintenance
#
# Copyright 2020 Observational Health Data Sciences and Informatics
#
# This file is part of CohortDiagnostics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

OhdsiRTools::updateCopyrightYearFolder()
devtools::spell_check()

# Create manual and vignettes:
unlink("extras/PhenotypeLibrary.pdf")
shell("R CMD Rd2pdf ./ --output=extras/PhenotypeLibrary.pdf")

# dir.create(path = "./inst/doc/", showWarnings = FALSE)
# rmarkdown::render("vignettes/PhenotypeLibrary.Rmd",
#                   output_file = "../inst/doc/PhenotypeLibrary.pdf",
#                   rmarkdown::pdf_document(latex_engine = "pdflatex",
#                                           toc = TRUE,
#                                           number_sections = TRUE))

pkgdown::build_site()

## Create package data
library(dplyr)

# get phenotype ids
dirs <- list.files("inst") %>%
  stringr::str_subset("\\d+")

# pull phenotype info into a dataframe
tidyPhenotype <- function(id){
  dfPhe <- readr::read_csv(glue::glue("inst/{id}/phenotypeDescription.csv"), col_types = "dcdccc")
  dfCohort <- readr::read_csv(glue::glue("inst/{id}/cohortDescription.csv"), col_types = "ddccd")

  dfPhe %>%
    left_join(dfCohort, by = "phenotypeId") %>%
    mutate(cohortJson = purrr::map(cohortId, ~jsonlite::read_json(glue::glue("inst/{id}/{.}.json")))) %>%
    mutate(cohortSql = purrr::map(cohortId, ~readr::read_file(glue::glue("inst/{id}/{.}.sql"))))
}

# Put all phenotypes into a single dataframe
phelib <- purrr::map_dfr(dirs, tidyPhenotype)

usethis::use_data(phelib)
