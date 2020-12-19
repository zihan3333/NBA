
team_id_finder = function(team_name){
  
  teams_list %>% filter(abbreviation %in% team_name |city %in% team_name |full_name %in% team_name  ) %>% pull(id)
  
}

player_id_finder = function(player_name){
  
  player_list %>% filter(tolower(full_name) %in% tolower(player_name)) %>% pull(id)
  
}


Find_team_H2H = function(team_name_A, team_name_B, period_from = as.Date("2017-01-01")){
leaguefinder_obj = nba$leaguegamefinder$LeagueGameFinder(team_id_nullable = team_id_finder(team_name_A), vs_team_id_nullable = team_id_finder(team_name_B))

team_vs_team_data = leaguefinder_obj$get_data_frames()[[1]]
team_vs_team_data %>% filter(GAME_DATE >=period_from) %>% mutate(OPP_PTS = PTS-PLUS_MINUS) %>% select(TEAM_NAME:WL,PTS,OPP_PTS,FGM:PF)
} 


