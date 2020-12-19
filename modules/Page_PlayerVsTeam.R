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
                  
                  ))
  
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
  
  
}