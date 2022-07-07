PhenotypeLibrary
================

[![Build Status](https://github.com/OHDSI/PhenotypeLibrary/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/PhenotypeLibrary/actions?query=workflow%3AR-CMD-check)
[![codecov.io](https://codecov.io/github/OHDSI/PhenotypeLibrary/coverage.svg?branch=main)](https://codecov.io/github/OHDSI/PhenotypeLibrary?branch=main)

Introduction
============
PhenotypeLibrary is a repository to store the content of the OHDSI Phenotype library. These phenotype/cohort definitions have under gone an OHDSI best practice Phenotype Development and Evaluation Process by the OHDSI Phenotype Development and Evaluation work group. This [workgroup](https://forums.ohdsi.org/t/ohdsi-phenotype-library-announcements/16910), through a OHDSI community wide collaboration effort, evaluates and maintains cohort definitions in an [Atlas instance](https://atlas-phenotype.ohdsi.org/#/home). Definitions that have graduated through this process are published in this repository, and are thus considered high quality cohort definitions.

cohortId's in this repository are persistent (similar to OMOP Concept Id) i.e. once published it maybe expected to stay the same between releases of the Phenotype library (i.e. backward compatible). Version numbers in this repository follows [HADES](https://ohdsi.github.io/Hades/index.html) convention, and changes (addition or deletions) are reported as [News](https://ohdsi.github.io/PhenotypeLibrary/news/index.html). Phenotype Development and Evaluation Workgroup will be responsible to maintain a cadence for the cohort life cycle - including deprecation and additions.

Features
========
- Contains all phenotypes (ie. cohort definitions) that have been approved by the OHDSI Phenotype Development and Evaluation workgroup.
- Phenotypes are available as SQL statements and JSON.
- Can provide cohortDefinitionSet object that maybe directly used as input by other OHDSI R packages like OHDSI [CohortGenerator](https://ohdsi.github.io/CohortGenerator/) and [CohortGenerator] (https://ohdsi.github.io/CohortDiagnostics/). See accompanying vignettes.

Technology
============
PhenotypeLibrary is an R package.

System Requirements
============
Requires R (version 3.6.0 or higher). 

Installation
=============
1. See the instructions [here](https://ohdsi.github.io/Hades/rSetup.html) for configuring your R environment, including RTools and Java.

2. In R, use the following commands to download and install PhenotypeLibrary:

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
Read [here](https://ohdsi.github.io/Hades/contribute.html) how you can contribute to this package.

License
=======
PhenotypeLibrary is licensed under Apache License 2.0

Development
===========
PhenotypeLibrary is being developed in R Studio.

### Development status

PhenotypeLibrary is under development.