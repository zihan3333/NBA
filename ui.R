ui = function(request){
    
    source_app_modules()
    source_app_functions()
    
    
    header = shinydashboardPlus::dashboardHeaderPlus(
        enable_rightsidebar = T,
        title = shiny::tags$div(
            h1("NBA", style = "font-weight:300; line-height:0.1")
            
        )
        
    )
    
    sidebar = dashboardSidebar(
        width = 250,
        withSpinner(
            sidebarMenuOutput('sidebarUI')
        )
    )
    
    body = dashboardBody(
        useShinyjs(),
        
        shiny::tags$style(".popover{max-width:100%;}"),
        shiny::tags$style(type = "text/css",
                          ".shiny-output-error {visibility:hidden; }",
                          ".shiny-output-error:before {visibility:hidden; }"
                          ),
        
        withSpinner(
            uiOutput('bodyUI')
        )
    )
    
    return(dashboardPagePlus(header,sidebar,body, title = "NBA"))
    
    
}
