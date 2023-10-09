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

#' Deprecated. List all phenotypes in the library.
#'
#' @return
#' A tibble with the cohort ID and name.
#' Deprecated. Please use getPhenotypeLog
#'
#' @examples
#' listPhenotypes()
#'
#' @export
listPhenotypes <- function() {
  .Deprecated(
    new = "getPhenotypeLog",
    msg = "listPhenotypes is deprecated. use getPhenotypeLog"
  )
  getPhenotypeLog()
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
#' cohorts <- getPhenotypeLog()
#' subsetIds <- cohorts$cohortId[1:3]
#' getPlCohortDefinitionSet(subsetIds)
#'
#' @export
getPlCohortDefinitionSet <- function(cohortIds) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertIntegerish(cohortIds, min.len = 1, add = errorMessages)
  checkmate::reportAssertions(collection = errorMessages)

  cohorts <- getPhenotypeLog(showHidden = TRUE) |>
    dplyr::filter(.data$cohortId %in% cohortIds) |>
    dplyr::select(
      "cohortId",
      "cohortName"
    )
  jsonFolder <- system.file("cohorts", package = "PhenotypeLibrary")
  sqlFolder <- system.file("sql", "sql_server", package = "PhenotypeLibrary")

  readFile <- function(fileName) {
    if (file.exists(fileName)) {
      return(paste(readr::read_lines(fileName), collapse = "\n"))
    }
  }

  getJsonAndSql <- function(i) {
    json <-
      readFile(file.path(jsonFolder, paste0(cohorts$cohortId[i], ".json")))
    sql <-
      readFile(file.path(sqlFolder, paste0(cohorts$cohortId[i], ".sql")))
    output <- cohorts[i, ] |>
      dplyr::mutate(
        json = !!json,
        sql = !!sql
      )
    return(output)
  }

  result <- lapply(seq_len(nrow(cohorts)), getJsonAndSql) |>
    dplyr::bind_rows()

  return(result)
}


#' Get phenotype log
#'
#' @return
#' Returns a table with one row per cohort definitions with log information such as its release cycle.
#' Example, this function gives us insight on when a cohort definition was added/updated/deprecated
#' by the OHDSI PhenotypeLibrary.
#'
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @param showHidden Some cohorts in the library are designed to be hidden. They are not
#'                   retrieved by default. To retrieve such cohorts, please set showHidden as TRUE.
#'                   Examples of hidden cohorts are withdrawn, deprecated, referrent cohorts.
#'
#' @return
#' A tibble.
#'
#' @examples
#' getPhenotypeLog(cohortIds = c(1, 2))
#'
#' @export
getPhenotypeLog <- function(cohortIds = NULL,
                            showHidden = FALSE) {
  checkmate::assertIntegerish(cohortIds,
    min.len = 0,
    null.ok = TRUE
  )

  cohorts <-
    readr::read_csv(system.file("Cohorts.csv", package = "PhenotypeLibrary"),
      col_types = readr::cols()
    )

  if (!showHidden) {
    cohorts <- cohorts |>
      dplyr::filter(!.data$isReferenceCohort == 1) |>
      dplyr::filter(
        stringr::str_detect(
          string = tolower(.data$status),
          pattern = "pending"
        ) |
          stringr::str_detect(
            string = tolower(.data$status),
            pattern = "accepted"
          )
      ) |>
      dplyr::filter(
        stringr::str_detect(
          string = .data$cohortName,
          pattern = stringr::fixed("[W]"),
          negate = TRUE
        )
      ) |>
      dplyr::filter(
        stringr::str_detect(
          string = .data$cohortName,
          pattern = stringr::fixed("[D]"),
          negate = TRUE
        )
      )
  }

  cohorts <- cohorts |>
    dplyr::mutate(
      newCohortName = dplyr::case_when(
        !is.na(.data$cohortNameLong) &
          cohortNameLong != "" ~ .data$cohortNameLong, !is.na(.data$cohortNameFormatted) &
          cohortNameFormatted != "" ~ .data$cohortNameFormatted,
        TRUE ~ .data$cohortName
      )
    ) |>
    dplyr::rename(
      cohortNameAtlas = .data$cohortName,
      cohortName = .data$newCohortName
    ) |>
    dplyr::relocate(
      .data$cohortId,
      .data$cohortName
    ) |>
    dplyr::arrange(.data$cohortId)

  cohorts <- transformColumns(cohorts)

  cohorts <- cohorts |>
    dplyr::mutate(
      addedDate = as.Date(.data$createdDate),
      updatedDate = as.Date(.data$modifiedDate)
    ) |>
    dplyr::arrange(.data$cohortId)

  if (!is.null(cohortIds)) {
    cohorts <- cohorts |>
      dplyr::filter(.data$cohortId %in% c(cohortIds))
  }
  return(cohorts)
}



#' Get conceptSets in cohorts
#'
#' @return
#' Returns a table with one row per concept set for given cohort definitions.
#'
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @return
#' A tibble.
#'
#' @examples
#' getPhenotypeLog(cohortIds = c(1, 2))
#'
#' @export
getPlConceptDefinitionSet <-
  function(cohortIds = getPhenotypeLog()$cohortId) {
    conceptSets <-
      system.file("ConceptSetsInCohortDefinition.RDS", package = "PhenotypeLibrary") |>
      readRDS()

    if (!is.null(cohortIds)) {
      conceptSets <- conceptSets |>
        dplyr::filter(.data$cohortId %in% c(cohortIds))
    }

    conceptSets <- transformColumns(df = conceptSets)

    return(conceptSets)
  }


# Function to transform columns based on conditions
transformColumns <- function(df) {
  # Iterate through each column
  for (col_name in names(df)) {
    col_data <- df[[col_name]]

    # If column contains alphabets
    if (any(grepl("[a-zA-Z]", col_data, ignore.case = TRUE))) {
      # Replace NA with empty string
      df[[col_name]][is.na(df[[col_name]])] <- ""
    }

    # If column contains only 0, 1, and NA
    else if (all(col_data %in% c(0, 1, NA))) {
      # Replace NA with 0
      df[[col_name]][is.na(df[[col_name]])] <- 0
    }
  }
  return(df |>
    dplyr::tibble())
}
