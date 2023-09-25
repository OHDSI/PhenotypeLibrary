# Copyright 2023 Observational Health Data Sciences and Informatics
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

rstudioapi::restartSession(command = "")
remotes::install_github("OHDSI/PhenotypeLibrary")



# this will source the script to update phenotypes
source("extras/UpdatePhenotypes.R")

stop("Please install the package")

#############
# install package
#################


# Format and check code ---------------------------------------------------
styler::style_pkg()
styler::style_dir(path = "extras")
OhdsiRTools::checkUsagePackage("PhenotypeLibrary")
OhdsiRTools::updateCopyrightYearFolder()

# Create manual -----------------------------------------------------------
unlink("extras/PhenotypeLibrary.pdf")
shell("R CMD Rd2pdf ./ --output=extras/PhenotypeLibrary.pdf")

# Create Vignettes---------------------------------------------------------
dir.create(file.path("inst", "doc"), showWarnings = FALSE, recursive = TRUE)
rmarkdown::render("vignettes/HowToUsePhenotypeLibraryRPackage.Rmd",
  output_file = "../inst/doc/HowToUsePhenotypeLibraryRPackage.pdf",
  rmarkdown::pdf_document(
    latex_engine = "pdflatex",
    toc = TRUE,
    number_sections = TRUE
  )
)

# rmarkdown::render("vignettes/CohortDefinitionsInOhdsiPhenotypeLibrary.Rmd",
#   output_file = "../inst/doc/CohortDefinitionsInOhdsiPhenotypeLibrary.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )

# rmarkdown::render(
#   "vignettes/ConceptSetDefinitionsInOhdsiPhenotypeLibrary.Rmd",
#   output_file = "../inst/doc/ConceptSetDefinitionsInOhdsiPhenotypeLibrary.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/CohortDefinitionSubmissionRequirements.Rmd",
#   output_file = "../inst/doc/CohortDefinitionSubmissionRequirements.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/GuidanceOnClinicalDescriptionForConditionPhenotypes.Rmd",
#   output_file = "../inst/doc/GuidanceOnClinicalDescriptionForConditionPhenotypes.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/ReservedWordsWithSpecialMeaningToPhenotypers.Rmd",
#   output_file = "../inst/doc/ReservedWordsWithSpecialMeaningToPhenotypers.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/GuidanceOnLiteratureReview.Rmd",
#   output_file = "../inst/doc/GuidanceOnLiteratureReview.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/GuidanceOnCohortDefinitionSetRObject.Rmd",
#   output_file = "../inst/doc/GuidanceOnCohortDefinitionSetRObject.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/ValidityChecksForCohortDefinitions.Rmd",
#   output_file = "../inst/doc/ValidityChecksForCohortDefinitions.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/SubmittedCohortDefinitions.Rmd",
#   output_file = "../inst/doc/SubmittedCohortDefinitions.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/GuidanceOnWritingAnEvaluationReport.Rmd",
#   output_file = "../inst/doc/GuidanceOnWritingAnEvaluationReport.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )
#
# rmarkdown::render("vignettes/GuidanceOnPerformingPeerReview.Rmd",
#   output_file = "../inst/doc/GuidanceOnPerformingPeerReview.pdf",
#   rmarkdown::pdf_document(
#     latex_engine = "pdflatex",
#     toc = TRUE,
#     number_sections = TRUE
#   )
# )



# Build site---------------------------------------------------------
pkgdown::build_site()
OhdsiRTools::fixHadesLogo()


# Cannot Release package to CRAN because of size restriction in CRAN ------------------------------------------------------
# devtools::check_win_devel()
#
# devtools::check_rhub()
#
# devtools::release()
#
# devtools::check(cran = TRUE)
