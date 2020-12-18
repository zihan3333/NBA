module_gameBoxScore_UI = function(id){
  ns = NS(id)
  fluidRow(
  tabBox(
    title = "Game Details", width = 12,
    # The id lets us use input$tabset1 on the server to find the current tab
    id = ns("tabset1"), height = NULL,
    tabPanel("Boxscore Traditional",
             
             DT::dataTableOutput(ns('boxScoreTraditional'))
             ),
    tabPanel("Tab2","" )
  )
  )
  
}


module_gameBoxScore_server = function(input, output, session, gameid){
  
  
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
    
    print(gameid)
  })
  
  output$boxScoreTraditional = renderDT({
    
    trad_table = nba$boxscoretraditionalv2$BoxScoreTraditionalV2(game_id = gameid)$get_data_frames()[[1]] %>% py_to_r() 
    
    return(DT::datatable(trad_table,options = list(scrollX=T)))
    
  })
} 