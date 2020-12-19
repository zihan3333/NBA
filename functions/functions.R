
team_id_finder = function(team_name){
  
  teams_list %>% filter(abbreviation %in% team_name |city %in% team_name |full_name %in% team_name  ) %>% pull(id)
  
}

player_id_finder = function(player_name){
  
  player_list %>% filter(tolower(full_name) %in% tolower(player_name)) %>% pull(id)
  
}

player_photo_url = function(player_id) {
  paste0("https://stats.nba.com/media/players/230x185/", player_id, ".png")
}


Find_team_H2H = function(team_name_A, team_name_B, period_from = as.Date("2017-01-01")){
leaguefinder_obj = nba$leaguegamefinder$LeagueGameFinder(team_id_nullable = team_id_finder(team_name_A), vs_team_id_nullable = team_id_finder(team_name_B))

team_vs_team_data = leaguefinder_obj$get_data_frames()[[1]]
team_vs_team_data %>% filter(GAME_DATE >=period_from) %>% mutate(OPP_PTS = PTS-PLUS_MINUS) %>% select(TEAM_NAME:WL,PTS,OPP_PTS,FGM:PF)
} 


find_next_opponent = function(playerid){
  Team_ids = nba$playernextngames$PlayerNextNGames(player_id = playerid)$get_data_frames()[[1]] %>% select(HOME_TEAM_ID,VISITOR_TEAM_ID) %>% head(1) %>% as.vector()
  player_team_id = nba$commonplayerinfo$CommonPlayerInfo(player_id = playerid)$get_data_frames()[[1]]$TEAM_ID
  opponent_team_id = setdiff(c(Team_ids[[1]],Team_ids[[2]]), player_team_id)
  Opponent_name = teams_list %>% filter(id == opponent_team_id) %>% pull(full_name)
  return(Opponent_name)
}
