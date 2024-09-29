# Copyright 2024 Observational Health Data Sciences and Informatics
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


# Create Vignettes---------------------------------------------------------
dir.create(file.path("inst", "doc"),
           showWarnings = FALSE,
           recursive = TRUE)
rmarkdown::render(
  "vignettes/HowToUsePhenotypeLibraryRPackage.Rmd",
  output_file = "../inst/doc/HowToUsePhenotypeLibraryRPackage.pdf",
  rmarkdown::pdf_document(
    latex_engine = "pdflatex",
    toc = TRUE,
    number_sections = TRUE
  )
)


# Build site---------------------------------------------------------
pkgdown::build_site()
OhdsiRTools::fixHadesLogo()
