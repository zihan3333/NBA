module_TeamDashboard_UI = function(id){
  
  ns = NS(id)
  fluidRow(
    tabBox(
      title = "Team Details", width = 12,
      # The id lets us use input$tabset1 on the server to find the current tab
      id = ns("tabset1"), height = NULL,
      tabPanel("TeamStats",
               fluidRow(
                 column(3, align= "center", selectInput(ns("season"),"Select Season", choices = c("2017-18","2018-19","2019-20"),  selected = "2019-20")),
                 column(3, align= "center", selectInput(ns("measureType"),"Select Measure Type", choices = c("Base","Advanced","Misc","Four Factors","Scoring","Opponent","Usage","Defense"),  selected = "Opponent")),
                 column(3, align= "center", selectInput(ns("position"),"Select Position", choices = c("None"= "","C","G","F"),  selected = "")),
                 column(3, align= "center", selectInput(ns("starterbench"),"Select Starter", choices = c("All"= "","Starters","Bench")))               
                        
                        ),
             
                 DT::dataTableOutput(ns('TeamStats'))
                 
               )
               
      ),
      tabPanel("Box Score Matchup", ""
               
      )
    )
  
}

module_TeamDashboard_server = function(input, output, session, team_name){
  
  ns = session$ns
  
  output_data = reactiveValues(TeamStats = NULL)
  
  observe({
    
  req(input$season)
  opp_name = teams_list %>% filter(abbreviation == team_name) %>% pull(full_name)
  opp_name = unlist(strsplit(opp_name," ")) %>% tail(1)
  print(opp_name)
  output_data$TeamStats = nba$leaguedashteamstats$LeagueDashTeamStats(season = input$season, measure_type_detailed_defense = input$measureType,player_position_abbreviation_nullable = input$position,
                                                                       starter_bench_nullable = input$starterbench,per_mode_detailed = "PerGame")$get_data_frames()[[1]] %>% mutate(id_match = ifelse(grepl(opp_name,TEAM_NAME),1,0))
    
  
    
  })
  
  output$TeamStats = renderDT({
    
    req(output_data$TeamStats)
    
    DT::datatable(output_data$TeamStats, options = list(scrollX=T, pageLength = nrow(output_data$TeamStats),
                                              lengthMenu = c(), dom = "t",
                                              autoWidth = F,
                                              columnDefs = list(
                                              list(width = "10px", targets = "_all"))), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe') %>% 
      formatStyle('id_match',
                  target = 'row',
                  backgroundColor = styleEqual(
                    1, c('yellow')
                  )
      )
    
  })
  
  
}