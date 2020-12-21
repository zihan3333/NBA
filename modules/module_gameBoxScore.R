module_gameBoxScore_UI = function(id){
  ns = NS(id)
  fluidRow(
  tabBox(
    title = "Game Details", width = 12,
    # The id lets us use input$tabset1 on the server to find the current tab
    id = ns("tabset1"), height = NULL,
    tabPanel("Boxscore Traditional",
               fluidRow(
                 column(6, align= "center",
                 uiOutput(ns("team_checkobox"))
                 ),
                 DT::dataTableOutput(ns('boxScoreTraditional'))
                 
               )

             ),
    tabPanel("Box Score Matchup",
             uiOutput(ns("Matchup_filter")),
             DT::dataTableOutput(ns('boxScoreMatchUp'))
             
             )
  )
  )
  
}


module_gameBoxScore_server = function(input, output, session, gameid){
  
  ns = session$ns
  
  output_data = reactiveValues(trad_table = NULL)
  observe({
    req(gameid)
    if(!isTruthy(gameid)){
      sendSweetAlert(
        session = session,
        title = "Error !!",
        text = "Please Highlight a Game Row before Checking Details",
        type = "error"
      )
    }
    
    output_data$trad_table = nba$boxscoretraditionalv2$BoxScoreTraditionalV2(game_id = gameid)$get_data_frames()[[1]]
    
    output_data$matchup_table = nba$boxscorematchups$BoxScoreMatchups(game_id = gameid)$get_data_frames()[[1]] 
    
    output$team_checkobox = renderUI({
      
      
      selectInput(
        inputId = ns("team_of_interest"),
        label = "Select Team",
        choices = unique(output_data$trad_table$TEAM_ABBREVIATION),
      )
      
    })
    
    output$Matchup_filter = renderUI({
      tagList(fluidRow(column(6,
        selectInput(
          inputId = ns("Offensiveplayer"),
          label = "Select Offsensive Player",
          choices = c("All", unique(output_data$matchup_table$OFF_PLAYER_NAME))
        )
      ),
      column(6,
             selectInput(
               inputId = ns("Dffensiveplayer"),
               label = "Select Defensive Player",
               choices = c("All", unique(output_data$matchup_table$DEF_PLAYER_NAME))
             )
             
             
             )))
      
    })

  })    
  
  output$boxScoreTraditional = renderDT({
    
    req(output_data$trad_table)
    
    tableoutput = output_data$trad_table %>% filter(!is.na(PTS)) %>% filter(TEAM_ABBREVIATION == input$team_of_interest) %>%
      select(PLAYER_NAME,MIN,PTS,OREB:TO, FGM:FT_PCT,PLUS_MINUS) 
    
    DT::datatable(tableoutput, options = list(scrollX=T, pageLength = nrow(tableoutput),
                                              lengthMenu = c(), dom = "t",
                                              autoWidth = F,
                                              columnDefs = list(
                                                list(width = "10px", targets = "_all"))), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe')
    
  })
  
  output$boxScoreMatchUp = renderDT({
    
    req(output_data$matchup_table)
    
    tableoutput = output_data$matchup_table %>% {if (input$Offensiveplayer != "All") filter(.,OFF_PLAYER_NAME == input$Offensiveplayer) else .} %>%
      {if (input$Dffensiveplayer != "All") filter(.,DEF_PLAYER_NAME == input$Dffensiveplayer) else .} %>%
      select(OFF_TEAM_ABBREVIATION,OFF_PLAYER_NAME,DEF_TEAM_ABBREVIATION,DEF_PLAYER_NAME,MATCHUP_MIN:MATCHUP_FG3_PCT) %>%
      arrange(desc(MATCHUP_MIN))
    
    DT::datatable(tableoutput, options = list(scrollX=T, pageLength = nrow(tableoutput),
                                              lengthMenu = c(), dom = "t",
                                              autoWidth = F,
                                              columnDefs = list(
                                              list(width = "10px", targets = "_all"))), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe')
    
  })
  
  
  

} 