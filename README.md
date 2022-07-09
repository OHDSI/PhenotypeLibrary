PhenotypeLibrary
================

[![Build Status](https://github.com/OHDSI/PhenotypeLibrary/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/PhenotypeLibrary/actions?query=workflow%3AR-CMD-check)
[![codecov.io](https://codecov.io/github/OHDSI/PhenotypeLibrary/coverage.svg?branch=main)](https://codecov.io/github/OHDSI/PhenotypeLibrary?branch=main)

Introduction
============
[PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary) is a repository to store the content of the [OHDSI Phenotype Library](https://github.com/OHDSI/PhenotypeLibrary) (Library). These phenotype/cohort definitions have under gone an OHDSI best practice Phenotype Development and Evaluation Process by the [OHDSI Phenotype Development and Evaluation Work group](https://teams.microsoft.com/l/team/19%3a66a11855657c46918723073bff9e36f1%40thread.tacv2/conversations?groupId=b464dca0-06d1-477c-b66d-11827e4d0412&tenantId=a30f0094-9120-4aab-ba4c-e5509023b2d5) (work group). This [Work group](https://teams.microsoft.com/l/team/19%3a66a11855657c46918723073bff9e36f1%40thread.tacv2/conversations?groupId=b464dca0-06d1-477c-b66d-11827e4d0412&tenantId=a30f0094-9120-4aab-ba4c-e5509023b2d5), through a OHDSI community wide collaboration effort, evaluates and maintains cohort definitions in an [Atlas instance](https://atlas-phenotype.ohdsi.org/#/home). Definitions that have graduated through this process are published in this repository, and are thus considered high quality cohort definitions.

cohortId's in this repository are persistent (similar to OMOP Concept Id) i.e. once published it maybe expected to stay the same between releases of the Phenotype library (i.e. backward compatible). Version numbers in this repository follows [HADES](https://ohdsi.github.io/Hades/index.html) convention, and changes (addition or deletions) are reported as [News](https://ohdsi.github.io/PhenotypeLibrary/news/index.html). [Work group](https://teams.microsoft.com/l/team/19%3a66a11855657c46918723073bff9e36f1%40thread.tacv2/conversations?groupId=b464dca0-06d1-477c-b66d-11827e4d0412&tenantId=a30f0094-9120-4aab-ba4c-e5509023b2d5) will be responsible to maintain a cadence for the cohort life cycle - including deprecation and additions.

Features
========
- Contains all phenotypes (i.e. cohort definitions) that have been approved by the OHDSI Phenotype Development and Evaluation workgroup.
- Phenotypes are available as SQL statements and JSON.
- Can provide cohortDefinitionSet object that maybe directly used as input by other OHDSI R packages like OHDSI [CohortGenerator](https://ohdsi.github.io/CohortGenerator/) and [CohortDiagnostics](https://ohdsi.github.io/CohortDiagnostics/). See accompanying vignettes.

Technology
============
[PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary) is an R package.

System Requirements
============
Requires R (version 3.6.0 or higher). 

Installation
=============
1. See [HADES instructions](https://ohdsi.github.io/Hades/rSetup.html) for configuring your R environment, including RTools and Java.

2. In R, use the following commands to download and install [PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary):

  ```r
  install.packages("remotes")
  remotes::install_github("ohdsi/PhenotypeLibrary")
  ```

User Documentation
==================
Documentation can be found on the [package website](https://ohdsi.github.io/PhenotypeLibrary).

PDF versions of the documentation are also available:
* Package manual: [PhenotypeLibrary.pdf](https://raw.githubusercontent.com/OHDSI/PhenotypeLibrary/main/extras/PhenotypeLibrary.pdf)

Support
=======
* Developer questions/comments/feedback: <a href="http://forums.ohdsi.org/c/developers">OHDSI Forum</a>
* We use the <a href="https://github.com/OHDSI/PhenotypeLibrary/issues">GitHub issue tracker</a> for all bugs/issues/enhancements

Contributing
============
Read [HADES contribution](https://ohdsi.github.io/Hades/contribute.html) how you can contribute to thee software in this package.
To contribute to the Cohort Definitions, Phenotype Development and Evaluation - please visit the Microsoft Teams website of the [OHDSI Phenotype Development and Evaluation Work group](https://teams.microsoft.com/l/team/19%3a66a11855657c46918723073bff9e36f1%40thread.tacv2/conversations?groupId=b464dca0-06d1-477c-b66d-11827e4d0412&tenantId=a30f0094-9120-4aab-ba4c-e5509023b2d5).

License
=======
[PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary) is licensed under Apache License 2.0

Development
===========
[PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary) is being developed in R Studio.

### Development status

[PhenotypeLibrary](https://github.com/OHDSI/PhenotypeLibrary) is under development.