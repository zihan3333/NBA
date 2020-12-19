Page_TeamVsTeam_UI = function(id){
  ns = NS(id)

  list(
  fluidRow(
      column(width = 6,
          uiOutput(ns("teamBanner1")),
          box(
            title = "Select Team 1", 
            width = 12,
            selectInput(ns("team_choice1"), label = "", choices = teams_list$full_name,selected = "Golden State Warriors")
          )
             
      ),
  
    column(6,
           uiOutput(ns("teamBanner2")),
           box(
             title = "Select Team 2", 
             width = 12,
             selectInput(ns("team_choice2"), label = "", choices = teams_list$full_name)
           ) 
           
         ),
    
    column(12,
    boxPlus(
      title = "H2H Details Since 2017", 
      closable = TRUE, 
      width = 12,
      status = "warning", 
      solidHeader = FALSE, 
      collapsible = TRUE,
      
      actionButton(ns('open_h2h_modal'),"By Game Details"),
      DT::dataTableOutput(ns('h2h_records'))

    ),
    
    bsModal(id = ns("gameBoxScoreModal"), title = "Game Details", trigger = ns("open_h2h_modal"), 
            #"SAdasd"
            module_gameBoxScore_UI(ns("h2h"))
            
            , size = "large")
    )
    
  )
  

  
  )

    
  
}

Page_TeamVsTeam_server = function(input,output, session){
  
  ns = session$ns
  
  # output$player_choice = renderUI({
  #   
  #   selectInput(ns("player_choice"), label = "", choices = teams_list$full_name)
  #   
  # })
  
  Gameid  = reactiveValues()
  
  output$teamBanner1 = renderUI({

             widgetUserBox(
               title = input$team_choice1,
               type = NULL,
               width = 12,
               src = "https://images.ctfassets.net/a4rx79jcl3n1/139uoz1HBz6PsWh8pEqOCK/eced155325ccb92acf76962ca5d688e5/gsw-logo-1920.png",
               color = "yellow",
               closable = TRUE,
               
               ""
             )
  })
  
  output$teamBanner2 = renderUI({
    
      widgetUserBox(
        title = input$team_choice2,
        type = NULL,
        width = 12,
        src = "https://i.pinimg.com/originals/a0/b3/c3/a0b3c351be5ddce6f90addf75858a38d.png",
        color = "purple",
        closable = TRUE
      )
    
  })
  

  
  observe({
    
    req(input$team_choice1)
    req(input$team_choice2)
    
    Gameid$H2H_table = Find_team_H2H(input$team_choice1, input$team_choice2)
    
    output$h2h_records = renderDT({
      
      DT::datatable(Gameid$H2H_table,options = list(scrollX=T), selection = 'single')
      
    })
    
  })
  
  observe({
    req(Gameid$H2H_table)
    Gameid$h2h_id = Gameid$H2H_table$GAME_ID[input$h2h_records_rows_selected] 
    print(Gameid$h2h_id)
    #module_gameBoxScore_server("h2h", game_id = reactive(Gameid$h2h_id))
    callModule(module = module_gameBoxScore_server, id = "h2h", gameid = Gameid$h2h_id)
  })
  
  

  
  
}
             

  