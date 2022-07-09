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

#' List all phenotypes in the library
#'
#' @return
#' A tibble with the cohort ID and name.
#'
#' @examples
#' listPhenotypes()
#'
#' @export
listPhenotypes <- function() {
  cohorts <- readr::read_csv(system.file("Cohorts.csv", package = "PhenotypeLibrary"), col_types = readr::cols())
  return(cohorts)
}

#' Get a cohort definition set
#'
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @return
#' A tibble with the cohort ID, name, sql, and JSON for the provided cohort IDs. Can be used by the
#' `CohortGenerator` package.
#'
#' @examples
#' cohorts <- listPhenotypes()
#' subsetIds <- cohorts$cohortId[1:3]
#' getPlCohortDefinitionSet(subsetIds)
#'
#' @export
getPlCohortDefinitionSet <- function(cohortIds) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertIntegerish(cohortIds, min.len = 1, add = errorMessages)
  checkmate::reportAssertions(collection = errorMessages)

  cohorts <- listPhenotypes() %>%
    filter(.data$cohortId %in% cohortIds)
  jsonFolder <- system.file("cohorts", package = "PhenotypeLibrary")
  sqlFolder <- system.file("sql", "sql_server", package = "PhenotypeLibrary")

  readFile <- function(fileName) {
    if (file.exists(fileName)) {
      return(paste(readr::read_lines(fileName), collapse = "\n"))
    }
  }

  getJsonAndSql <- function(i) {
    json <- readFile(file.path(jsonFolder, paste0(cohorts$cohortId[i], ".json")))
    sql <- readFile(file.path(sqlFolder, paste0(cohorts$cohortId[i], ".sql")))
    cohorts[i, ] %>%
      mutate(
        json = !!json,
        sql = !!sql
      ) %>%
      return()
  }

  result <- lapply(seq_len(nrow(cohorts)), getJsonAndSql) %>%
    bind_rows()

  return(result)
}


#' Get phenotype log
#'
#' @return
#' Returns a table with one row per cohort definitions with log information such as its release cycle.
#' Example, this function gives us insight on when a cohort definition was added/updated/deprecated
#' by the OHDSI PhenotypeLibrary.
#'
#' @examples
#' getPhenotypeReport(cohortIds = c(1, 2))
#'
#' @export
getPhenotypeLog <- function(cohortIds = listPhenotypes()$cohortId) {
  log <-
    readr::read_csv(
      system.file("PhenotypeLog.csv", package = "PhenotypeLibrary"),
      col_types = readr::cols()
    ) %>% 
    dplyr::filter(.data$cohortId %in% c(cohortIds)) %>% 
    dplyr::arrange(.data$cohortId)
  return(log)
}
