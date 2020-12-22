Page_PlayerVsTeam_UI = function(id){
  ns = NS(id)
  
  team_choice = teams_list$abbreviation
  names(team_choice) = teams_list$full_name
  fluidRow(column(3,
                  boxPlus(
                    title = "Select Your Player", 
                    status = "success",
                    width = 12,
                    uiOutput(ns("PlayerBanner")),
                    selectInput(ns("player_choice"), label = "Player", choices = player_list$full_name, selected = "Stephen Curry"),
                    
                    tags$h2("VS",  align = "center"),
                    
                    selectInput(ns("team_choice"), label = "Team", choices = team_choice),
                    awesomeCheckbox(
                      inputId = ns("next_matchup"),
                      label = "Use Next Matchup", 
                      value = TRUE,
                      status = "info"
                    )
                   
                  )
                  
                  ),
           
           column(9,
                  
                  boxPlus(
                    width = 12,
                    title = "Summary Statistics", 
                    closable = TRUE, 
                    status = "warning", 
                    solidHeader = FALSE, 
                    collapsible = TRUE,
                    enable_sidebar = TRUE,
                    sidebar_width = 25,
                    sidebar_start_open = F,
                    sidebar_content = 
                      tagList(
                      selectInput(ns("season_brief"),"Select Season",choices = c("2017-18","2018-19","2019-20"), selected = "2019-20"),
                      selectInput(ns("mode_brief"),"Select Mode",choices = c("Totals","PerGame","Per36"), selected = "PerGame")
                    ),
                    tabBox(
                      title = "Game Details", width = 12,
                      # The id lets us use input$tabset1 on the server to find the current tab
                      id = ns("tabset1"), height = NULL,
                      tabPanel("GameSplit vs Team",
                               
                               DT::dataTableOutput(ns('DashboardOpponent')),
                               
                               br(),
                               h2("Specific Performance"),
                               actionButton(ns('open_GameSpecfic_modal'),"Check Details"),
                               DT::dataTableOutput(ns('gamelogsSpecfic'))
                               
                               
                      ),
                      tabPanel("Recent performance",
                               actionButton(ns('open_GameRecent_modal'),"Check Details"),
                               DT::dataTableOutput(ns('gamelogRecent')),
                               
                               "" )
                      
                    ),
                    
                    bsModal(id = ns("gameRecentModal"), title = "Game Details", trigger = ns("open_GameRecent_modal"), 
                            module_gameBoxScore_UI(ns("gamelogsRecent"))
                            
                            , size = "large")
                    ),
                    bsModal(id = ns("gameSpecficModal"), title = "Game Details", trigger = ns("open_GameSpecfic_modal"), 
                          module_gameBoxScore_UI(ns("gamelogsSpecfic"))
                          
                          , size = "large")
                   ),
                    br(),
                    br()
                    
                  )
                  
           
           
  
}

Page_PlayerVsTeam_server = function(input,output, session){
  
  ns = session$ns
  
  output_data = reactiveValues()
  
  output$PlayerBanner = renderUI({
    tryCatch({
    tags$img(
      src = player_photo_url(player_id_finder(input$player_choice)),
      alt = "photo",
      style = "  display: block;
      margin-left: auto;
      margin-right: auto;
      width: 80%;"
    )
    }, error = function(error_condition) {
      message(error_condition)
    })
    
    
  })
  
  observe({
    req(input$player_choice)
    tryCatch({
    next_opponent = find_next_opponent(player_id_finder(input$player_choice))
    if(input$next_matchup){
      updateSelectInput(session,inputId = "team_choice", selected = next_opponent)
    }
    }, error = function(error_condition) {
      message(error_condition)
    })
  })
  
  observe({
    
    req(input$player_choice)
    playerid = player_id_finder(input$player_choice)
    season = input$season_brief
    mode = input$mode_brief
    output_data$dashboard_by_opp = nba$playerdashboardbyopponent$PlayerDashboardByOpponent(player_id = playerid,season = season, per_mode_detailed = mode)$get_data_frames()
    
    output_data$gamelogs = nba$playergamelog$PlayerGameLog(player_id = playerid,season = "ALL")$get_data_frames()[[1]]
    output_data$gamelogsRecent = output_data$gamelogs%>% head(20)
    
    output_data$gamelogsSpecfic  = nba$playergamelog$PlayerGameLog(player_id = playerid, season = season)$get_data_frames()[[1]] %>% filter(grepl(input$team_choice,MATCHUP))
    
    opp_name = teams_list %>% filter(abbreviation ==input$team_choice) %>% pull(full_name)
    opp_name = unlist(strsplit(opp_name," ")) %>% tail(1)
    
    output$DashboardOpponent = renderDT({
      table = output_data$dashboard_by_opp[[4]] %>% select(GROUP_VALUE,GP,MIN,PTS,REB,AST,TOV,STL,BLK,FGM:FG3_PCT) %>% mutate(id_match = ifelse(grepl(opp_name,GROUP_VALUE),1,0)) %>%
      formattable(list(PTS =  color_tile("transparent", "lightpink"), 
                       REB =  color_tile("transparent", "lightpink"), 
                       AST =  color_tile("transparent", "lightpink"), 
                       TOV =  color_tile("transparent", "lightgreen"), 
                       FG_PCT = color_bar("lightblue"),
                       FG3_PCT = color_bar("lightblue")
                       
                       )) %>%
      as.datatable(options = list(scrollX=T, pageLength = nrow(.), lengthMenu = c(), dom = "t"), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe') %>% 
        formatStyle('id_match',
                    target = 'row',
                    backgroundColor = styleEqual(
                      1, c('yellow')
                    )
        )
    
    
  })
    
  })
  
  output$gamelogRecent = renderDT({
    req(output_data$gamelogsRecent)
    output_data$gamelogsRecent %>% select(GAME_DATE:MIN,PTS,REB,AST:BLK,FGM:FG3_PCT) %>%
      formattable(list(PTS =  color_tile("transparent", "lightpink"), 
                       REB =  color_tile("transparent", "lightpink"), 
                       AST =  color_tile("transparent", "lightpink"), 
                       FG_PCT = color_bar("lightblue"),
                       FG3_PCT = color_bar("lightblue")
                       
      )) %>%
        as.datatable(options = list(scrollX=T, pageLength = nrow(.), lengthMenu = c(), dom = "t"), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe') 
    
  })
  
  observe({
    req(output_data$gamelogsRecent)
    gamelogsRecent_id = output_data$gamelogsRecent$Game_ID[input$gamelogRecent_rows_selected] 
    callModule(module = module_gameBoxScore_server, id = "gamelogsRecent", gameid = gamelogsRecent_id)
  })
  
  output$gamelogsSpecfic = renderDT({
    req(output_data$gamelogsSpecfic)
    output_data$gamelogsSpecfic %>% select(GAME_DATE:MIN,PTS,REB,AST:BLK,FGM:FG3_PCT) %>%
      formattable(list(PTS =  color_tile("transparent", "lightpink"), 
                       REB =  color_tile("transparent", "lightpink"), 
                       AST =  color_tile("transparent", "lightpink"), 
                       FG_PCT = color_bar("lightblue"),
                       FG3_PCT = color_bar("lightblue")
                       
      )) %>%
      as.datatable(options = list(scrollX=T, pageLength = nrow(.), lengthMenu = c(), dom = "t"), fillContainer = FALSE, selection = 'single',class = 'cell-border stripe') 
    
  })
  
  observe({
    req(output_data$gamelogsSpecfic)
    id = output_data$gamelogsSpecfic$Game_ID[input$gamelogsSpecfic_rows_selected] 
    callModule(module = module_gameBoxScore_server, id = "gamelogsSpecfic", gameid = id)
  })
  
  
}