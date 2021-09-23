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

#' Execute the cohort diagnostics
#'
#' @details
#' This function executes the cohort diagnostics.
#'
#' @param connectionDetails                   An object of type \code{connectionDetails} as created
#'                                            using the
#'                                            \code{\link[DatabaseConnector]{createConnectionDetails}}
#'                                            function in the DatabaseConnector package.
#' @param cdmDatabaseSchema                   Schema name where your patient-level data in OMOP CDM
#'                                            format resides. Note that for SQL Server, this should
#'                                            include both the database and schema name, for example
#'                                            'cdm_data.dbo'.
#' @param cohortDatabaseSchema                Schema name where intermediate data can be stored. You
#'                                            will need to have write privileges in this schema. Note
#'                                            that for SQL Server, this should include both the
#'                                            database and schema name, for example 'cdm_data.dbo'.
#' @param vocabularyDatabaseSchema            Schema name where your OMOP vocabulary data resides. This
#'                                            is commonly the same as cdmDatabaseSchema. Note that for
#'                                            SQL Server, this should include both the database and
#'                                            schema name, for example 'vocabulary.dbo'.
#' @param cohortTable                         The name of the table that will be created in the work
#'                                            database schema. This table will hold the exposure and
#'                                            outcome cohorts used in this study.
#' @param tempEmulationSchema                 Some database platforms like Oracle and Impala do not
#'                                            truly support temp tables. To emulate temp tables,
#'                                            provide a schema with write privileges where temp tables
#'                                            can be created.
#' @param verifyDependencies                  Check whether correct package versions are installed?
#' @param outputFolder                        Name of local folder to place results; make sure to use
#'                                            forward slashes (/). Do not use a folder on a network
#'                                            drive since this greatly impacts performance.
#' @param databaseId                          A short string for identifying the database (e.g.
#'                                            'Synpuf').
#' @param databaseName                        The full name of the database (e.g. 'Medicare Claims
#'                                            Synthetic Public Use Files (SynPUFs)').
#' @param databaseDescription                 A short description (several sentences) of the database.
#' @param incrementalFolder                   Name of local folder to hold the logs for incremental
#'                                            run; make sure to use forward slashes (/). Do not use a
#'                                            folder on a network drive since this greatly impacts
#'                                            performance.
#'
#' @export
execute <- function(connectionDetails,
                    cdmDatabaseSchema,
                    vocabularyDatabaseSchema = cdmDatabaseSchema,
                    cohortDatabaseSchema = cdmDatabaseSchema,
                    cohortTable = "cohort",
                    tempEmulationSchema = cohortDatabaseSchema,
                    verifyDependencies = TRUE,
                    outputFolder,
                    incrementalFolder = file.path(outputFolder, "incrementalFolder"),
                    databaseId = "Unknown",
                    databaseName = databaseId,
                    databaseDescription = databaseId) {
  if (!file.exists(outputFolder)) {
    dir.create(outputFolder, recursive = TRUE)
  }
  ParallelLogger::addDefaultFileLogger(file.path(outputFolder, "log.txt"))
  ParallelLogger::addDefaultErrorReportLogger(file.path(outputFolder, "errorReportR.txt"))
  on.exit(ParallelLogger::unregisterLogger("DEFAULT_FILE_LOGGER", silent = TRUE))
  on.exit(
    ParallelLogger::unregisterLogger("DEFAULT_ERRORREPORT_LOGGER", silent = TRUE),
    add = TRUE
  )
  
  if (verifyDependencies) {
    ParallelLogger::logInfo("Checking whether correct package versions are installed")
    verifyDependencies()
  }
  
  ParallelLogger::logInfo("Creating cohorts")
  CohortDiagnostics::instantiateCohortSet(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDatabaseSchema = cohortDatabaseSchema,
    vocabularyDatabaseSchema = vocabularyDatabaseSchema,
    cohortTable = cohortTable,
    tempEmulationSchema = tempEmulationSchema,
    packageName = "phenotypeLibrary",
    cohortToCreateFile = "settings/CohortsToCreate.csv",
    createCohortTable = TRUE,
    generateInclusionStats = TRUE,
    inclusionStatisticsFolder = outputFolder,
    incremental = TRUE,
    incrementalFolder = incrementalFolder
  )
  
  ParallelLogger::logInfo("Running study diagnostics")
  CohortDiagnostics::runCohortDiagnostics(
    packageName = "phenotypeLibrary",
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    vocabularyDatabaseSchema = vocabularyDatabaseSchema,
    tempEmulationSchema = getOption("sqlRenderTempEmulationSchema"),
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTable = cohortTable,
    inclusionStatisticsFolder = outputFolder,
    exportFolder = file.path(outputFolder, "diagnosticsExport"),
    databaseId = databaseId,
    databaseName = databaseName,
    databaseDescription = databaseDescription,
    minCellCount = 5,
    incremental = TRUE,
    incrementalFolder = incrementalFolder
  )
}
