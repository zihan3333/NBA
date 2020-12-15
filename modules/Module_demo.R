page_model_mgt_UI = function(id){
  ns = NS(id)
  
  list(
    fluidRow(
      
      box(width = 12,status = "primary",
          "xxxxxxxxxxx")
      
    ),
    textOutput(ns("placeholder"))
    
  )
  
}


page_model_mgt_server = function(input,output, session){
  output$placeholder = renderText({
    
    
    "Awesonme"
  })
  
} 