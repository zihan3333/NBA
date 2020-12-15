requiredPackages = c("reticulate","shinydashboard","shinydashboardPlus")
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
