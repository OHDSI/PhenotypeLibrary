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

verifyDependencies <- function() {
  expected <- jsonlite::fromJSON("renv.lock")
  expected <- dplyr::bind_rows(expected[[2]])
  basePackages <- rownames(installed.packages(priority = "base"))
  expected <- expected[!expected$Package %in% basePackages, ]
  observedVersions <- sapply(sapply(expected$Package, packageVersion), paste, collapse = ".")
  expectedVersions <- sapply(sapply(expected$Version, numeric_version), paste, collapse = ".")
  mismatchIdx <- which(observedVersions != expectedVersions)
  if (length(mismatchIdx) > 0) {
    
    lines <- sapply(mismatchIdx, function(idx) sprintf("- Package %s version %s should be %s",
                                                       expected$Package[idx],
                                                       observedVersions[idx],
                                                       expectedVersions[idx]))
    message <- paste(c("Mismatch between required and installed package versions. Did you forget to run renv::restore()?",
                       lines),
                     collapse = "\n")
    stop(message)
  }
}
