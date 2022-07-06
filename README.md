PhenotypeLibrary
================

[![Build Status](https://github.com/OHDSI/PhenotypeLibrary/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/PhenotypeLibrary/actions?query=workflow%3AR-CMD-check)
[![codecov.io](https://codecov.io/github/OHDSI/PhenotypeLibrary/coverage.svg?branch=main)](https://codecov.io/github/OHDSI/PhenotypeLibrary?branch=main)

Introduction
============
PhenotypeLibrary is a repository to store the content of the OHDSI Phenotype library.

Features
========
- Contains all approved phenotypes (ie. cohort definitions) of the OHDSI Phenotype Library.
- Phenotypes are available as SQL statements and JSON.
- Can directly be used with the OHDSI [CohortGenerator](https://ohdsi.github.io/CohortGenerator/) package to instantiate cohorts.

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