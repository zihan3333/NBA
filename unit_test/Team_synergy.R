library(parallel)

numCores <- detectCores()
cl <- makeCluster(numCores)

clusterEvalQ(cl, {
  library(dplyr)
  library(reticulate)
  nba = import("nba_api.stats.endpoints")
})

playtype_player = function(player_name, type_grouping = "offensive", player_or_Team = "P", season = "2020-21"){

playerid = player_id_finder(player_name) 
playtypes = c("Cut", "Handoff","Isolation", "Misc","OffScreen","Postup","PRBallHandler","PRRollman","OffRebound","Spotup","Transition")

synergy_list = parLapply(cl,playtypes, function(x){
  
 nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = x, season = season, type_grouping_nullable = type_grouping, player_or_team_abbreviation = "P")$get_data_frames()[[1]] %>%
 filter(PLAYER_ID == playerid) %>% mutate(PTS_Per_G = PTS/GP) %>% select(PLAYER_NAME,TEAM_NAME:FG_PCT,EFG_PCT,PTS_Per_G)
  
})

return(do.call(rbind,synergy_list))

}


playtype_team = function(team_name, type_grouping = "defensive", season = "2020-21", by_players = F){
  
  teamid = team_id_finder(team_name) 
  playtypes = c("Cut", "Handoff","Isolation", "Misc","OffScreen","Postup","PRBallHandler","PRRollman","OffRebound","Spotup","Transition")
  
  synergy_list = parLapply(cl,playtypes, function(x){
    if(!by_players){
    nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = x, season = season, type_grouping_nullable = type_grouping, player_or_team_abbreviation = "T")$get_data_frames()[[1]] %>%
      filter(TEAM_ID == teamid)  %>% mutate(PTS_Per_G = as.numeric(PTS)/as.numeric(GP)) %>% select(TEAM_NAME:FG_PCT,EFG_PCT,PTS_Per_G)
    }else{
      nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = x, season = season, type_grouping_nullable = type_grouping, player_or_team_abbreviation = "P")$get_data_frames()[[1]] %>%
        filter(TEAM_ID == teamid) %>% mutate(PTS_Per_G = as.numeric(PTS)/as.numeric(GP)) %>% select(PLAYER_NAME,TEAM_NAME:FG_PCT,EFG_PCT,PTS_Per_G)
    }
    
  })
  
  final_output = if(!by_players) do.call(rbind,synergy_list) %>% arrange(PERCENTILE) else do.call(rbind,synergy_list) %>% arrange(PLAY_TYPE,desc(POSS_PCT))
  return(final_output)
  
}

playtype("jamal murray")

team1 = "DEN"
team2 = "UTA"



playtype_team(team2) %>% View()
playtype_team(team1, type_grouping = "offensive",by_players = T)
playtype_team(team2, type_grouping = "defensive",by_players = T)
