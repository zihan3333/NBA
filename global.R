

if(Sys.getenv("USERNAME") == "shiny"){
  
  library(reticulate)
  library(shiny)
  library(shinydashboard)
  library(shinydashboardPlus)
  library(shinyWidgets)
  library(shinyjs)
  library(shinycssloaders)
  library(styler)
  library(shinyAce)
  library(shinyjqui)
  library(data.table)
  library(dplyr)
  library(DT)
  library(shinyBS)
  
  for(i in 1:length(Sys.getenv())){
  message(names(Sys.getenv())[i])
  message(strwrap(Sys.getenv()[i]))
  }
  reticulate::virtualenv_create(envname = './python3_env', 
                                #python = "C:/Users/zihan/Anaconda3/envs/r-reticulate"
                                
                                python = '/usr/bin/python3'
                                )
  
  reticulate::virtualenv_install('./python3_env', 
                                 packages = c('numpy',"pandas","nba_api"))
  
  #Sys.setenv(RETICULATE_PYTHON = "~/.virtualenvs/python3_env/bin/python")
  
  #Sys.setenv(RETICULATE_PYTHON = "~/.virtualenvs/python3_env/bin/python")
  
  #reticulate::use_virtualenv('python3_env', required = T)
} else {
  
  requiredPackages = c("reticulate","shiny", "shinydashboard","shinydashboardPlus","shinyWidgets","shinyjs","shinycssloaders",
                       "styler","shinyAce","shinyjqui","data.table","dplyr","DT","shinyBS")
  
  installedPackages = rownames(installed.packages())
  missingPackages = requiredPackages[!requiredPackages%in%installedPackages]
  if (length(missingPackages)>0) install.packages(missingPackages)
  for(package in requiredPackages) suppressPackageStartupMessages(library(package,character.only = T))
}


source_app_modules = function(){
  modules.sources = list.files('modules',pattern = '^.+\\.[rR]$',full.names = T,recursive = T)
  sapply(modules.sources,source)
}

source_app_modules()

source_app_functions = function(){
  modules.sources = list.files('functions',pattern = '^.+\\.[rR]$',full.names = T,recursive = T)
  sapply(modules.sources,source)
}

source_app_functions()

teams_list = fread("team_list.csv")
player_list = fread("player_list.csv")

#use_python("/C:/Users/zihan/AppData/Local/Programs/Python/Python37")
#reticulate::py_config()
nba = import("nba_api.stats.endpoints")
