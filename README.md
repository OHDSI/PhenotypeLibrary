# OHDSI Phenotype Library <img src="man/figures/OHDSIlogo.png" align="right" width="120" />

The Cohort Definitions that are part of the OHDSI Phenotype Library are maintained in a security enabled Atlas instance by the OHDSI Phenotype Development and Evaluation Workgroup. Please sign up for access to https://atlas-phenotype.ohdsi.org the official Atlas for OHDSI Phenotype Library using the Google form here https://docs.google.com/forms/d/e/1FAIpQLSc9GlhvFiPVVuIQ-9Oc8esbFDX6Lrg2y4m_bYvI_0MxsPQlUQ/viewform>

This github repository is currently under maintenance. Do not use. Please use the Atlas link referenced above.


<!-- README.md is generated from README.Rmd. Please edit that file -->



<!-- badges: start -->

[![Lifecycle:
deprecated](https://lifecycle.r-lib.org/articles/figures/lifecycle-deprecated.svg)](https://www.tidyverse.org/lifecycle/#deprecated)
<!-- badges: end -->

OHDSI Phenotype Library is an open community resource maintained by the
OHDSI community to support phenotype development, evaluation, sharing
and re-use. The Phenotype Library is maintained by community librarians.
They are volunteer collaborators who are curating the content
contributed by the rest of the community to ensure it is appropriately
organized and conforms to community library standards.

The OHDSI Phenotype work group is responsible to facilitate the
generation and maintenance of the content in the library. To be
included, every cohort definition is expected to belong to one
Phenotype, and it should have at least one full result set from Cohort
Diagnostics executed on at least one data source. The output should have
been contributed to the Phenotype library.

All cohort definitions in the phenotype library are expressed in JSON
and SQL (OHDSI SQL) instructions that are compatible with OHDSI analytic
tools and OHDSI OMOP CDM v5.0+. Supporting content are in folders
literature, notes and evaluation. Literature review is organized using a
standardized template.

Studies may be executed by importing the definitions into OHDSI tools
and compiling study executable (see <https://github.com/OHDSI-studies>).

## Installation

You can download and install the released version of PhenotypeLibrary
from [GitHub](https://github.com/OHDSI/PhenotypeLibrary) with:

``` r
remotes::install_github("OHDSI/PhenotypeLibrary")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("OHDSI/PhenotypeLibrary", ref = "develop")
```
