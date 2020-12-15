requiredPackages = c("reticulate","shinydashboard","shinydashboardPlus")
installedPackages = rownames(installed.packages())
missingPackages = requiredPackages[!requiredPackages%in%installedPackages]

if (length(missingPackages)>0) install.packages(missingPackages)
for(package in requiredPackages) suppressPackageStartupMessages(library(package,character.only = T))
