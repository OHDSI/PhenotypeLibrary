# Copyright 2022 Observational Health Data Sciences and Informatics
#
# This file is part of PhenotypeLibrary
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

# Format and check code ---------------------------------------------------
styler::style_pkg()
OhdsiRTools::checkUsagePackage("PhenotypeLibrary")
OhdsiRTools::updateCopyrightYearFolder()

source("extras/UpdatePhenotypes.R")

# Create manual -----------------------------------------------------------
unlink("extras/PhenotypeLibrary.pdf")
shell("R CMD Rd2pdf ./ --output=extras/PhenotypeLibrary.pdf")

# Create Vignettes---------------------------------------------------------
dir.create(file.path("inst", "doc"), showWarnings = FALSE, recursive = TRUE)
rmarkdown::render("vignettes/HowToUsePhenotypeLibraryRPackage.Rmd",
                  output_file = "../inst/doc/HowToUsePhenotypeLibraryRPackage.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/CohortDefinitionsInOhdsiPhenotypeLibrary.Rmd",
                  output_file = "../inst/doc/CohortDefinitionsInOhdsiPhenotypeLibrary.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/CohortDefinitionSubmissionRequirements.Rmd",
                  output_file = "../inst/doc/CohortDefinitionSubmissionRequirements.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/GuidelinesOnClinicalDescriptionForConditionPhenotypes.Rmd",
                  output_file = "../inst/doc/GuidelinesOnClinicalDescriptionForConditionPhenotypes.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/ReservedWordsWithSpecialMeaningToPhenotypers.Rmd",
                  output_file = "../inst/doc/ReservedWordsWithSpecialMeaningToPhenotypers.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/GuidelinesOnLiteratureReview.Rmd",
                  output_file = "../inst/doc/GuidelinesOnLiteratureReview.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/GuidelinesOnCohortDefinitionSetRObject.Rmd",
                  output_file = "../inst/doc/GuidelinesOnCohortDefinitionSetRObject.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/ValidityChecksForCohortDefinitions.Rmd",
                  output_file = "../inst/doc/ValidityChecksForCohortDefinitions.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))

rmarkdown::render("vignettes/SubmittedCohortDefinitions.Rmd",
                  output_file = "../inst/doc/SubmittedCohortDefinitions.pdf",
                  rmarkdown::pdf_document(latex_engine = "pdflatex",
                                          toc = TRUE,
                                          number_sections = TRUE))



# Build site---------------------------------------------------------
pkgdown::build_site()
OhdsiRTools::fixHadesLogo()
