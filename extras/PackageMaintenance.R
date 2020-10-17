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
