Page_PlayerVsTeam_UI = function(id){
  ns = NS(id)
  
  fluidRow(column(3,
                  boxPlus(
                    title = "Select Your Player", 
                    status = "success",
                    width = 12,
                    uiOutput(ns("PlayerBanner")),
                    selectInput(ns("player_choice"), label = "Player", choices = player_list$full_name, selected = "Stephen Curry"),
                    
                    tags$h2("VS",  align = "center"),
                    
                    selectInput(ns("team_choice"), label = "Team", choices = teams_list$full_name),
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
                      tabPanel("Defense vs Team",
                               
                               DT::dataTableOutput(ns('DashboardOpponent'))
                      ),
                      tabPanel("Tab2","" )
                    ),
                    br(),
                    br()
                    
                  )
                  
                  )
           
           
           )
  
}

Page_PlayerVsTeam_server = function(input,output, session){
  
  ns = session$ns
  
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
    dashboard_by_opp = nba$playerdashboardbyopponent$PlayerDashboardByOpponent(player_id = playerid,season = season, per_mode_detailed = mode)$get_data_frames()
    opp_name = unlist(strsplit(input$team_choice," ")) %>% tail(1)
    
    output$DashboardOpponent = renderDT({
      table = dashboard_by_opp[[4]] %>% select(GROUP_VALUE,GP,MIN,PTS,REB,AST,TOV,STL,BLK,FGM:FG3_PCT) %>% mutate(id_match = ifelse(grepl(opp_name,GROUP_VALUE),1,0)) %>%
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
  
  
}