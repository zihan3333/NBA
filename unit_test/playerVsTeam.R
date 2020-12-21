
playerid = player_id_finder("lebron james")
Team_ids = nba$playernextngames$PlayerNextNGames(player_id = playerid)$get_data_frames()[[1]] %>% select(HOME_TEAM_ID,VISITOR_TEAM_ID) %>% head(1) %>% as.vector()
player_team_id = nba$commonplayerinfo$CommonPlayerInfo(player_id = playerid)$get_data_frames()[[1]]$TEAM_ID
opponent_team_id = setdiff(c(Team_ids[[1]],Team_ids[[2]]), player_team_id)
Opponent_name = teams_list %>% filter(id == opponent_team_id) %>% pull(full_name)


