server = function(input,output,session){
    
    source_app_modules()
    source_app_functions()
    
    menuItems = list(
        
        list(
            tabName = 'TeamVsTeam', parentTab = NULL, text = "TeamVsTeam",icon = "database",
            namespace = "tvt",server_module = "Page_TeamVsTeam_server",ui_module = "Page_TeamVsTeam_UI"
        ),
        list(
            tabName = 'PlayerVsTeam', parentTab = NULL, text = "PlayerVsTeam",icon = "database",
            namespace = "pvt",server_module = "page_model_mgt_server",ui_module = "page_model_mgt_UI"
        )
        
    )
    
    disabledItems = sapply(menuItems, function(x){
        !is.null(x[['disabled']]) && x[['disabled']]
    })
    menuItems = menuItems[!disabledItems]
    
    output$sidebarUI = renderMenu({
        
        buildMenuItems = function(itemList,parentTab = NULL){
            out = list()
            
            for(item in itemList) {
                
                if( ( is.null(parentTab) && !is.null(item[['parentTab']])) ||
                    (!is.null(parentTab) &&  is.null(item[['parentTab']])) ||
                    (!is.null(parentTab) && item$parentTab != parentTab) ) next()
                
                subTabsIndex = lapply(itemList,'[[','parentTab') == item[['tabName']]
                
                if(!any(subTabsIndex) || is.null(subTabsIndex)){
                    out = append(out, list(menuItem(text = item[['text']], tabName = item[['tabName']], icon = shiny::icon(item[['icon']]),badgeLabel = item[['badgeLabel']] )))
                next()
                } else {
                    args = list(text = item[['text']], tabName = item[['tabName']], icon = shiny::icon(item[['icon']]),badgeLabel = item[['badgeLabel']])
                    args = c(args, buildMenuItems(itemList, parentTab = item[['tabName']]))
                    out = append(out,list(do.call('menuItem',args = args)))
                    next()
                }
                
            }
            
            return(out)
        }
        
        items.list = buildMenuItems(menuItems)
        
        return(sidebarMenu(id = 'sidebarmenu',.list = items.list))
        
    })
    
    output$bodyUI = renderUI({
        
        body_loop_func = function(inList){
            
            output = list()
            for (item in inList){
                
                if(!is.null(item[['namespace']]) && !is.null(item[['ui_module']])){
                    output = append(output,list(list(tabName = item$tabName, namespace = item$namespace, ui_module = item$ui_module)))
                }
            }
            return(output)
            
        }
        
        body_tab_func  = function(inList){
            
            to_do =  body_loop_func(inList)
            
            tabs = lapply(to_do, function(x){
                
                tryCatch(
                    expr = shinydashboard::tabItem(tabName = x$tabName,get(x$ui_module)(x$namespace)),
                    warning = function(w){return(NULL)},
                    error = function(e) {return(NULL)}
                    
                )
                
                
            })
            return(tabs)
            
        }
        tabs.list =body_tab_func(menuItems)
        return(do.call('tabItems',args = tabs.list))
        
    })
    
    callModuleServerNames = function(itemList){
        
        out = lapply(itemList,function(x){
            if(!is.null(x[['namespace']]) && !is.null(x[['server_module']])){
                callModule(module = get(x[['server_module']]), id = x[['namespace']])
            }
        })
        
        return(out)
    }
    
    d = callModuleServerNames(menuItems)
    
    
    
}

    