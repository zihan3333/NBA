h2h = Find_team_H2H("ATL","LAL")

game_id  = h2h$GAME_ID[1]
team_id = team_id_finder("ATL")
opp_team_id = team_id_finder("LAL")

playerid = player_id_finder("lebron james")

,measure_type_detailed = "Usage"
dashboard_by_opp = nba$playerdashboardbyopponent$PlayerDashboardByOpponent(player_id = playerid,season = "2019-20",per_mode_detailed = "PerGame")$get_data_frames()
dashboard_by_opp[[1]]$PTS

laker_defense = nba$matchupsrollup$MatchupsRollup(season = "2019-20", per_mode_simple = "PerGame",def_team_id_nullable = opp_team_id)$get_data_frames()[[1]]

find_playerDetails = function(player_name){
  playerid = player_id_finder(player_name)
  details = nba$commonplayerinfo$CommonPlayerInfo(player_id = playerid)$get_data_frames()[[1]]
  return(list())
}

find_player_position("lebron james")

teamdashboardbyopponent.TeamDashboardByOpponent(team_id = teams.find_team_by_abbreviation('gsw')['id'],season = "2017-18",period =1, per_mode_detailed = "PerGame").get_data_frames()

#useful
boxscore = nba$boxscoreadvancedv2$BoxScoreAdvancedV2(game_id = game_id)$get_data_frames()
boxscore[[1]] %>% py_to_r() 

boxscoreDef = nba$boxscoredefensive$BoxScoreDefensive(game_id = game_id)$get_data_frames()[[1]]


nba$boxscorefourfactorsv2$BoxScoreFourFactorsV2(game_id = game_id)$get_data_frames()[[2]] %>% py_to_r() %>%head()

#useful
matchups = nba$boxscorematchups$BoxScoreMatchups(game_id = game_id)$get_data_frames()[[1]] 

x = "LeBron James"
y =  "Jabari Parker"
tableoutput = matchups %>% {if (x != "All") filter(.,OFF_PLAYER_NAME == x)} %>%
  {if (y != "All") filter(.,DEF_PLAYER_NAME == y)} %>%
  select(OFF_TEAM_ABBREVIATION,OFF_PLAYER_NAME,DEF_TEAM_ABBREVIATION,DEF_PLAYER_NAME,MATCHUP_MIN:MATCHUP_FG3_PCT) 

#useful
boxscorescoringv2

#useful
nba$boxscoretraditionalv2$BoxScoreTraditionalV2(game_id = game_id)$get_data_frames()[[1]] %>% filter(!is.na(PTS))

nba$boxscoreusagev2$BoxScoreUsageV2(game_id = game_id)$get_data_frames()[[1]] %>% py_to_r()

nba$hustlestatsboxscore$HustleStatsBoxScore(game_id = game_id)$get_data_frames()[[2]] %>% py_to_r()



nba$commonplayerinfo$CommonPlayerInfo(player_id = playerid)$get_data_frames()[[1]]%>% py_to_r() #POSITION

nba$cumestatsplayer$CumeStatsPlayer(player_id = playerid, game_ids = game_id)$get_data_frames()[[1]]%>% py_to_r()
            
#could be useful               
nba$homepageleaders$HomePageLeaders(season = "2018-19",stat_category = "Rebounds")$get_data_frames()[[1]] %>% py_to_r() 
# (Points)|(Rebounds)|(Assists)|(Defense)|(Clutch)|(Playmaking)|(Efficiency)|(Fast Break)|(Scoring Breakdown)

nba$leaguedashoppptshot$LeagueDashOppPtShot(season = "2018-19")$get_data_frames()[[1]]  %>% py_to_r() 

teamvsplayer = lapply(nba$teamvsplayer$TeamVsPlayer(team_id = team_id, opponent_team_id =opp_team_id ,season = "2018-19")$get_data_frames(), function(x) py_to_r(x))
teamvsplayer[[7]]
