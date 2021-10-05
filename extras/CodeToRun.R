
library(magrittr)

# Maximum number of cores to be used:
maxCores <- parallel::detectCores()

################################################################################
# VARIABLES - please change below this line
################################################################################
# The folder where the study intermediate and result files will be written:
outputFolder <- "D:\\studyResults\\phenotypeLibraryP"

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
# This is optional, as andromeda is able to assign temporary location using your Operating Systems (OS) settings, 
# but sometimes the temporary location specified by your OS may not have sufficient storage space.
# To avoid such scenarios, it maybe useful to change and uncomment the line below to point to 
# a location on your disk drive that has sufficient space.
options(andromedaTempFolder = file.path(outputFolder, "andromedaTemp"))

# create output directory if it doesnt exist
if (!dir.exists(outputFolder)) {
        dir.create(outputFolder, showWarnings = FALSE, recursive = TRUE)
}

################################################################################
# WORK
################################################################################

# Details for connecting to the server:
connectionDetails <-
        DatabaseConnector::createConnectionDetails(
                dbms = "pdw",                       # example: 'redshift'
                server = Sys.getenv("PDW_SERVER"),  # example: 'fdsfd.yourdatabase.yourserver.com"
                user = NULL,
                password = NULL,
                port = Sys.getenv("PDW_PORT")       # example: 2234
        )

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDM_IBM_MDCD_V1153.dbo"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "scratch.dbo"
cohortTable <- "rao_skeleton"

# Some meta-information that will be used by the export function:
databaseId <- "Synpuf"
databaseName <-
        "Medicare Claims Synthetic Public Use Files (SynPUFs)"
databaseDescription <-
        "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

execute(
        connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        verifyDependencies = TRUE,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription
)

CohortDiagnostics::preMergeDiagnosticsFiles(dataFolder = outputFolder)

CohortDiagnostics::launchDiagnosticsExplorer(dataFolder = outputFolder)


# Upload the results to the OHDSI SFTP server:
privateKeyFileName <- ""
userName <- ""
phenotypeLibrary::uploadResults(outputFolder, privateKeyFileName, userName)
