# Note: this assumes Microsoft SQL Server database, using integrated authentication
# ServerKey: any value you want to use to uniquely identify the server
# Dialect: the value from SQLRender's dialect list (this algorithm only suppors mssql and pdw dialects)
# hostname: the host of your DB server
# port: the port to connect to the DB server

# databaseKey: a unique identifier you can create to identify the database in the server
# databaseName: The name of the database in the server
# schema: where to find the CDM tables in the database

# note, you can have a list of servers and within each server a list of databases to execute this on. The results will be stored in the
# destination schema that will be created for each server you define.

serverList <- list(buildServer("{ServerKey}", "{dialect}", "{hostname}", {port}, # duplicate this for each server
                              list(
                                 buildDatabase("{databaseKey}", "{databaseName}", "{schemaName}"),
                                 buildDatabase("{databaseKey}", "{databaseName}", "{schemaName}") # duplicate this for each db
                              ))
                   );
clean(serverList, "{DestinationSchema}", "{tablePrefix}"); # removes the tables created by the algorithm from your target servers/databases
init(serverList, "{DestinationSchema}", "{tablePrefix}"); # initalizes the tables created on each target server
execute(serverList, "{DestinationSchema}", "{tablePrefix}"); # executes the algorithm storing the results created in the init() call.

