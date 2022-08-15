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
      addedNotes = as.character(.data$addedNotes),
      deprecatedVersion = as.character(.data$deprecatedVersion),
      deprecatedDate = as.Date(.data$deprecatedDate),
      deprecatedNotes = as.character(.data$deprecatedNotes),
      updatedVersion = as.character(.data$updatedVersion),
      updatedDate = as.Date(.data$updatedDate),
      updatedNotes = as.character(.data$updatedNotes)
    ) %>%
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

  updates <- updates %>%
    dplyr::mutate(description = as.character(.data$description)) %>%
    tidyr::replace_na(replace = list(description = ""))

  oldLog <- getPhenotypeLog()

  # Peer Review-----------------------
  peerReview <- updates %>%
    dplyr::filter(stringr::str_detect(
      string = .data$name,
      pattern = stringr::fixed("[P]")
    )) %>%
    dplyr::mutate(
      cohortId = .data$id,
      cohortName = .data$name,
      addedDate = as.Date(.data$createdDate),
      addedVersion = "NA",
      getResults = "No",
      addedNotes = as.character(.data$description),
      updatedDate = as.Date(.data$modifiedDate)
    )
  peerReview <- peerReview %>%
    dplyr::select(dplyr::all_of(intersect(
      colnames(oldLog), colnames(peerReview)
    )))

  oldLogUpdated <- dplyr::bind_rows(
    oldLog %>%
      dplyr::anti_join(
        y = peerReview %>%
          dplyr::select(.data$cohortId) %>%
          dplyr::distinct(),
        by = "cohortId"
      ),
    peerReview
  ) %>%
    dplyr::arrange(.data$cohortId)
  oldLogUpdated <- oldLogUpdated %>%
    dplyr::select(dplyr::all_of(intersect(
      colnames(oldLog), colnames(oldLogUpdated)
    )))

  # New Cohorts -----------------------
  newCohorts <- updates %>%
    dplyr::anti_join(
      oldLogUpdated %>%
        dplyr::select(.data$cohortId) %>%
        dplyr::rename(id = .data$cohortId) %>%
        dplyr::distinct(),
      by = "id"
    ) %>%
    dplyr::mutate(
      cohortId = .data$id,
      cohortName = .data$name,
      addedDate = as.Date(.data$createdDate),
      addedVersion = "NA",
      getResults = "No",
      addedNotes = as.character(.data$description),
      updatedDate = as.Date(.data$modifiedDate)
    )
  newCohorts <- newCohorts %>%
    dplyr::select(dplyr::all_of(intersect(
      colnames(oldLog), colnames(newCohorts)
    ))) %>%
    dplyr::arrange(.data$cohortId)

  # Updated -----------------------
  updated <- updates %>%
    dplyr::mutate(
      cohortId = .data$id,
      addedDate = as.Date(.data$createdDate),
      updatedDate = as.Date(.data$modifiedDate)
    ) %>%
    dplyr::anti_join(
      y = oldLogUpdated %>%
        dplyr::select(
          .data$cohortId,
          .data$addedDate,
          .data$updatedDate
        ),
      by = "cohortId"
    ) %>%
    dplyr::arrange(.data$cohortId)

  # In Active Deprecate -----------------------
  deprecated <- updates %>%
    dplyr::filter(stringr::str_detect(
      string = .data$name,
      pattern = stringr::fixed("[D]")
    )) %>%
    dplyr::select(
      .data$id,
      .data$modifiedDate,
      .data$description
    ) %>%
    dplyr::mutate(
      deprecatedDate = as.Date(.data$modifiedDate),
      deprecatedVersion = "XX"
    ) %>%
    dplyr::rename(
      cohortId = .data$id,
      deprecatedNotes = .data$description
    )

  # InActive Error -----------------------
  error <- updates %>%
    dplyr::filter(stringr::str_detect(
      string = .data$name,
      pattern = stringr::fixed("[E]")
    )) %>%
    dplyr::select(
      .data$id,
      .data$modifiedDate,
      .data$description
    ) %>%
    dplyr::mutate(
      deprecatedDate = as.Date(.data$modifiedDate),
      deprecatedVersion = "XX"
    ) %>%
    dplyr::rename(
      cohortId = .data$id,
      deprecatedNotes = .data$description
    )

  # InActive Withdrawn -----------------------
  withDrawn <- updates %>%
    dplyr::filter(stringr::str_detect(
      string = .data$name,
      pattern = stringr::fixed("[W]")
    )) %>%
    dplyr::select(
      .data$id,
      .data$modifiedDate,
      .data$description
    ) %>%
    dplyr::mutate(
      deprecatedDate = as.Date(.data$modifiedDate),
      deprecatedVersion = "XX"
    ) %>%
    dplyr::rename(
      cohortId = .data$id,
      deprecatedNotes = .data$description
    )

  toDeprecate <- dplyr::bind_rows(
    deprecated,
    error,
    withDrawn
  ) %>%
    dplyr::mutate(getResults = "No") %>%
    dplyr::arrange(.data$cohortId)
  #
  updateDeprecation <- oldLogUpdated %>%
    dplyr::inner_join(
      y = toDeprecate %>%
        dplyr::select(.data$cohortId),
      by = "cohortId"
    ) %>%
    dplyr::select(
      -.data$updatedDate, -.data$deprecatedNotes, -.data$deprecatedDate, -.data$deprecatedVersion, -.data$getResults
    ) %>%
    dplyr::inner_join(toDeprecate,
      by = "cohortId"
    ) %>%
    dplyr::mutate(getResults = "No")
  #
  updateTrue <- oldLogUpdated %>%
    dplyr::filter(.data$cohortId %in% c(updated$cohortId)) %>%
    dplyr::anti_join(
      y = toDeprecate %>%
        dplyr::select(.data$cohortId),
      by = "cohortId"
    )
  #
  updatedFinal <- dplyr::bind_rows(
    updateDeprecation,
    updateTrue
  )
  updatedFinal <- updatedFinal %>%
    dplyr::select(dplyr::all_of(intersect(
      colnames(oldLog), colnames(updatedFinal)
    )))

  log <- dplyr::bind_rows(
    oldLogUpdated,
    updatedFinal,
    newCohorts
  ) %>%
    dplyr::distinct() %>%
    dplyr::arrange(.data$cohortId)
  return(log)
}
