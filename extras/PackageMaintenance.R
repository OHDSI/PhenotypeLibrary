# Copyright 2021 Observational Health Data Sciences and Informatics
#
# This file is part of phenotypeLibrary
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
# OhdsiRTools::formatRFolder()
OhdsiRTools::checkUsagePackage("phenotypeLibrary")
OhdsiRTools::updateCopyrightYearFolder()

# Create manual -----------------------------------------------------------
unlink("extras/UsingSkeletonPackage.pdf")
shell("R CMD Rd2pdf ./ --output=extras/UsingSkeletonPackage.pdf")

# Store environment in which the study was executed -----------------------
OhdsiRTools::createRenvLockFile(rootPackage = "phenotypeLibrary",
                                additionalRequiredPackages = c('keyring', "checkmate","DatabaseConnector","clock","dplyr","DT",
                                                               "ggplot2","ggiraph","gtable","htmltools","lubridate",
                                                               "pool","purrr","scales","shiny","shinydashboard","shinyWidgets",
                                                               "stringr","SqlRender","tidyr", "plyr"))




