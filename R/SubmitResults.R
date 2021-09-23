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

#' Upload results to OHDSI server
#'
#' @details
#' This function uploads the 'Results_<databaseId>.zip' to the OHDSI SFTP server. Before sending, you
#' can inspect the zip file, which contains (zipped) CSV files. You can send the zip file from a
#' different computer than the one on which is was created.
#'
#' @param privateKeyFileName   A character string denoting the path to the RSA private key provided by
#'                             the study coordinator.
#' @param userName             A character string containing the user name provided by the study
#'                             coordinator.
#' @param outputFolder         Name of local folder where the results were generated; make sure to use
#'                             forward slashes (/). Do not use a folder on a network drive since this
#'                             greatly impacts performance.
#' @export
uploadResults <- function(outputFolder, privateKeyFileName, userName) {
  fileName <- list.files(outputFolder, "^Results_.*.zip$", full.names = TRUE)
  if (length(fileName) == 0) {
    writeLines("Looking for diagnosticsExport subfolder")
    fileName <- list.files(file.path(outputFolder, "diagnosticsExport"), "diagnosticsExport", "^Results_.*.zip$", full.names = TRUE)
  }
  if (length(fileName) == 0) {
    stop("Could not find results file in folder. Did you run (and complete) execute?")
  }
  if (length(fileName) == 0) {
    stop("Multiple results files found. Don't know which one to upload")
  }
  OhdsiSharing::sftpUploadFile(privateKeyFileName = privateKeyFileName,
                               userName = userName,
                               remoteFolder = "cohortEvaluation",
                               fileName = fileName)
  ParallelLogger::logInfo("Finished uploading")
}
