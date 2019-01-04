#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(broom) #For table

connectionDetails<-DatabaseConnector::createConnectionDetails(dbms="sql server",
                                                              server="",
                                                              schema="",
                                                              user="",
                                                              password="")
cdmDatabaseSchema <- ""
resultsDatabaseSchema <- ""
cdmVersion <- "" 
connection<-DatabaseConnector::connect(connectionDetails)
cohortTable = "ischemic_stroke_phenotypes"

ui<-fluidPage(
        titlePanel("Phenotype Validator"),
        
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        numericInput ("seed", "random seed", value = 1, verbatimTextOutput("value")),
                        numericInput ("prop", "sampling proportion (0 to 1.0)", value = 0.1, min = 0, max = 1),
                        numericInput ("cohortDefinitionId", "Cohort Definition Id", value = 1),
                        actionButton ("definitionEnter", "Change the setting")
                        
                ),
                mainPanel(
                        verbatimTextOutput("eventId"),
                        verbatimTextOutput("dischargeNote"),
                        #tableOutput("tab1"),
                        
                        radioButtons("result", 
                                     label = "The result of validation", 
                                     choices = c("valid", "invalid", "inconclusive")),
                        #selectInput ("result", "The result of validation", choices = c("valid", "invalid", "inconclusive")),
                        textInput ("comment", "Additional comment", verbatimTextOutput("txt")),
                        tableOutput("outputTab"),
                        actionButton("show", "Show"),
                        actionButton("validationEnter", "Enter the result of validation")
                        
                )
                
        ),
        downloadButton("downloadData", "download the validation result")
        
        ##additional information (drug, procedure, condition)
        #tableOutput("conditionTab"),
        #tableOutput("drugTab"),
        #tableOutput("procedureTab"),

)

server <-function(input,output,session){
        dfs<-data.frame()
        output$eventId<-renderText({sprintf("%d th event", input$validationEnter+1)})
        
        observeEvent(input$definitionEnter,{
                sql <- "SELECT TOP 1000 * 
                FROM @target_database_schema.@target_cohort_table co
                INNER JOIN @cdm_database_schema.visit_occurrence visit
                ON co.subject_id = visit.person_id AND co.cohort_start_date = visit.visit_start_date
                INNER JOIN CDMPv1.dbo.NOTE note
                ON co.subject_id = note.person_id AND visit.visit_end_date = note.note_date
                WHERE co.cohort_definition_id = @target_cohort_id"
                
                sql <- SqlRender::renderSql(sql,
                                            cdm_database_schema=cdmDatabaseSchema,
                                            target_database_schema=resultsDatabaseSchema,
                                            target_cohort_table=cohortTable,
                                            target_cohort_id=as.numeric(input$cohortDefinitionId)
                                            )$sql
                sql <- SqlRender::translateSql(sql,
                                               targetDialect=connectionDetails$dbms)$sql
                cohort<-DatabaseConnector::querySql(connection, sql)
                
                colnames(cohort)<-SqlRender::snakeCaseToCamelCase(colnames(cohort))
                cohortWithNote<<-cohort
                
                
        })
        
        outputTxt<-reactive({
                req(input$show)
                cohortWithNoteInterest<<-cohortWithNote[input$show,]
                noteText<-gsub("<[^<>]*>","\n" ,cohortWithNoteInterest$noteText)
                noteText<-gsub("EMR","",noteText)
                noteText<-gsub("&#x0D;","",noteText)
                #cohortWithNoteInterest$noteText
                
        })
        output$dischargeNote <- renderText({outputTxt()})
        
        observeEvent(input$validationEnter,{
                df<-cohortWithNoteInterest[,c("cohortDefinitionId","subjectId","noteId", "visitOccurrenceId",
                                              "cohortStartDate","visitStartDate","visitEndDate","noteDate",
                                              "visitTypeConceptId","admittingSourceConceptId","noteTypeConceptId","noteClassConceptId"
                )]
                df$validation<-input$result
                df$comment<-input$comment
                dfs<<-rbind(dfs,df)
                write.csv(dfs,"df.csv")
                
        })
        
        output$downloadData <- downloadHandler(
                filename = function(){
                        file.path("data","result.csv")
                },
                content = function(file){
                        write.csv(dfs,file)
                }
        )
        
}

shinyApp(ui,server)