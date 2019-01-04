setwd("~/git/ABMI/PhenotypeLibrary/ischemic stroke")

OhdsiRTools::insertCohortDefinitionSetInPackage(fileName = "settings.csv",
                                                baseUrl = "http://.../WebAPI",
                                                insertTableSql = TRUE,
                                                insertCohortCreationR = TRUE,
                                                generateStats = FALSE,
                                                packageName="ischemicStrokePhenotype")





                         