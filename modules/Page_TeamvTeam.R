Page_TeamVsTeam_UI = function(id){
  ns = NS(id)
  
  list(
  actionButton(ns("run"),"RUN"),
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
      DT::dataTableOutput(ns('h2h_records'))

    )
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
  
  output$h2h_records = renderDT({
    
    H2H_table = Find_team_H2H(input$team_choice1, input$team_choice2)
    DT::datatable(H2H_table,options = list(scrollX=T))
    
  })
  
  
  
}
             

  