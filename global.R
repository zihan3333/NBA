requiredPackages = c("reticulate","shiny", "shinydashboard","shinydashboardPlus","shinyWidgets","shinyjs","shinycssloaders",
                     "styler","shinyAce","shinyjqui","data.table","dplyr","DT","shinyBS")

installedPackages = rownames(installed.packages())
missingPackages = requiredPackages[!requiredPackages%in%installedPackages]

if (length(missingPackages)>0) install.packages(missingPackages)
for(package in requiredPackages) suppressPackageStartupMessages(library(package,character.only = T))

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

nba = import("nba_api.stats.endpoints")
