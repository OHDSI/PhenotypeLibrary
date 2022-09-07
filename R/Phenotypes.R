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
#' @param cohortIds  IDs of cohorts to extraction from the library.
#'
#' @return
#' A tibble.
#'
#' @examples
#' getPhenotypeLog(cohortIds = c(1, 2))
#'
#' @export
getPhenotypeLog <- function(cohortIds = listPhenotypes()$cohortId) {
  log <-
    readr::read_csv(
      system.file("PhenotypeLog.csv", package = "PhenotypeLibrary"),
      col_types = readr::cols()
    ) %>%
    dplyr::filter(.data$cohortId %in% c(cohortIds)) %>%
    dplyr::mutate(
      addedVersion = as.character(.data$addedVersion),
      addedDate = as.Date(.data$addedDate),
      deprecatedVersion = as.character(.data$deprecatedVersion),
      deprecatedDate = as.Date(.data$deprecatedDate),
      updatedVersion = as.character(.data$updatedVersion),
      updatedDate = as.Date(.data$updatedDate),
      notes = as.character(.data$notes),
    ) %>%
    tidyr::replace_na(replace = list(
      getResults = "No",
      addedVersion = "",
      deprecatedVersion = "",
      updatedVersion = "",
      notes = ""
    )) %>%
    dplyr::arrange(.data$cohortId)
  return(log)
}


#' Update phenotype log
#'
#' @return
#' Updates Phenotype Log related to added/updated/deprecated of the OHDSI PhenotypeLibrary.
#'
#' @param updates  Data to update to the log. This is usually the output of ROhdsiWebApi::getCohortDefinitionsMetaData(baseUrl = baseUrl)
#'
#' @return
#' A tibble.
#'
#' @export
updatePhenotypeLog <- function(updates) {
  errorMessages <- checkmate::makeAssertCollection()
  checkmate::assertDataFrame(
    x = updates,
    min.rows = 1,
    min.cols = 5,
    add = errorMessages
  )
  checkmate::reportAssertions(collection = errorMessages)

  oldLog <- getPhenotypeLog()

  phenotypeLog <- updates %>%
    dplyr::mutate(
      addedDate = as.Date(.data$createdDate),
      updatedDate = as.Date(.data$modifiedDate),
      cohortId = .data$id,
      cohortName = .data$name,
      notes = as.character(.data$description)
    ) %>%
    dplyr::mutate( # peer evaluation
      updatedDate = dplyr::case_when(
        .data$cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = .data$cohortName,
              pattern = "[P]"
            )) %>%
            dplyr::pull(.data$cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # withdrawn
      updatedDate = dplyr::case_when(
        .data$cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = .data$cohortName,
              pattern = "[W]"
            )) %>%
            dplyr::pull(.data$cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # deprecated
      updatedDate = dplyr::case_when(
        .data$cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = .data$cohortName,
              pattern = "[D]"
            )) %>%
            dplyr::pull(.data$cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    dplyr::mutate( # error
      updatedDate = dplyr::case_when(
        .data$cohortId %in% c(
          oldLog %>%
            dplyr::filter(stringr::str_detect(
              string = .data$cohortName,
              pattern = "[E]"
            )) %>%
            dplyr::pull(.data$cohortId)
        ) ~ as.Date(NA)
      )
    ) %>%
    tidyr::replace_na(replace = list(notes = "")) %>%
    dplyr::select(
      .data$cohortId,
      .data$cohortName,
      .data$addedDate,
      .data$updatedDate,
      .data$notes
    ) %>%
    dplyr::arrange(.data$cohortId)

  noChanges <- phenotypeLog %>%
    dplyr::inner_join(oldLog,
      by = c(
        "cohortId",
        "cohortName",
        "addedDate",
        "updatedDate",
        "notes"
      )
    )

  withChanges <- phenotypeLog %>%
    dplyr::anti_join(oldLog,
      by = c(
        "cohortId",
        "cohortName",
        "addedDate",
        "updatedDate",
        "notes"
      )
    )

  changes <- dplyr::tibble()

  # Peer Review-----------------------
  peerReview <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = .data$cohortName,
      pattern = stringr::fixed("[P]")
    )) %>%
    dplyr::mutate(
      addedVersion = "NA",
      getResults = "No"
    )

  # Deprecated
  deprecated <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = .data$cohortName,
      pattern = stringr::fixed("[D]")
    )) %>%
    dplyr::mutate(
      deprecatedVersion = "XX",
      deprecatedDate = .data$updatedDate,
      getResults = "No"
    )

  # Withdrawn
  withDrawn <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = .data$cohortName,
      pattern = stringr::fixed("[W]")
    )) %>%
    dplyr::mutate(getResults = "No")

  # Error
  error <- withChanges %>%
    dplyr::filter(stringr::str_detect(
      string = .data$cohortName,
      pattern = stringr::fixed("[E]")
    )) %>%
    dplyr::mutate(
      deprecatedVersion = "XX",
      deprecatedDate = .data$updatedDate,
      getResults = "No"
    )

  # New Cohorts -----------------------
  newCohorts <- withChanges %>%
    dplyr::filter(
      !.data$cohortId %in% c(
        peerReview$cohortId,
        deprecated$cohortId,
        withDrawn$cohortId,
        error$cohortId
      ) %>% unique()
    ) %>%
    dplyr::mutate(
      addedVersion = "XX",
      getResults = "Yes"
    )

  changes <-
    dplyr::bind_rows(
      peerReview,
      deprecated,
      withDrawn,
      error,
      newCohorts
    )

  log <-
    dplyr::bind_rows(noChanges, changes) %>%
    dplyr::arrange(.data$cohortId) %>%
    dplyr::select(
      .data$cohortId,
      .data$cohortName,
      .data$getResults,
      .data$addedDate,
      .data$addedVersion,
      .data$deprecatedDate,
      .data$deprecatedVersion,
      .data$updatedDate,
      .data$updatedVersion,
      .data$notes
    )

  return(log)
}
