Page_TeamVsTeam_UI = function(id){
  ns = NS(id)
  
  uiOutput(ns("teamBanner"))

    
  
}

Page_TeamVsTeam_server = function(input,output, session){
  
  ns = session$ns
  
  output$player_choice = renderUI({
    
    selectInput(ns("player_choice"), label = "", choices = teams_list$full_name)
    
  })
  
  output$teamBanner = renderUI({
    
    fluidRow(
      column(width = 6,
             widgetUserBox(
               title = isolate({input$player_choice}),
               type = NULL,
               width = 12,
               src = "https://images.ctfassets.net/a4rx79jcl3n1/139uoz1HBz6PsWh8pEqOCK/eced155325ccb92acf76962ca5d688e5/gsw-logo-1920.png",
               color = "yellow",
               closable = TRUE,
               uiOutput(ns("player_choice")),
               footer = "The footer here!"
             )),
      
      column(6,
             widgetUserBox(
               title = "LA lakers",
               type = NULL,
               width = 12,
               src = "https://i.pinimg.com/originals/a0/b3/c3/a0b3c351be5ddce6f90addf75858a38d.png",
               color = "purple",
               closable = TRUE,
               "Some text here!",
               footer = "The footer here!"
             )
             
             
             )
             
             
  )
    
    
 
  })
}
  