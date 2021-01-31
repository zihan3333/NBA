h2h = Find_team_H2H("ATL","LAL")

game_id  = h2h$GAME_ID[1]
team_id = team_id_finder("ATL")
opp_team_id = team_id_finder("LAL")

playerid = player_id_finder("lebron james")

#want Defense and Opponent
#^(Base)|(Advanced)|(Misc)|(Four Factors)|(Scoring)|(Opponent)|(Usage)|(Defense)$
nba$leaguedashteamstats$LeagueDashTeamStats(season = "2019-20", measure_type_detailed_defense = "Opponent",player_position_abbreviation_nullable = "")$get_data_frames()

# playtype"
#USE p AND T to switch between players and Team. 
type_grouping = "defensive"
player_or_team = "T" #P
nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = c("Isolation","Postup"), season = "2019-20",type_grouping_nullable = type_grouping, player_or_team_abbreviation = player_or_team)$get_data_frames()

testframe =  nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = c("Isolation","Postup"), season = "2019-20",type_grouping_nullable = type_grouping, player_or_team_abbreviation = player_or_team)$get_data_frames()[[1]]

unique(testframe$PLAY_TYPE)  
nba$leaguedashpla

playtypes = c("Cut", "Handoff","Isolation", "Misc","OffScreen","Postup","PRBallHandler","PRRollman","OffRebound","Spotup","Transition")

irving_stats = lapply(playtypes, function(x){
  nba$synergyplaytypes$SynergyPlayTypes(play_type_nullable = x, season = "2020-21", type_grouping_nullable = "offensive", player_or_team_abbreviation = "P")$get_data_frames()[[1]] %>%
    filter(PLAYER_NAME == "Kyrie Irving")
 
})

dashboard_by_opp = nba$playerdashboardbyopponent$PlayerDashboardByOpponent(player_id = playerid,season = "2019-20",per_mode_detailed = "PerGame",measure_type_detailed = "Defense")$get_data_frames()
dashboard_by_opp[[1]]$PTS

laker_defense = nba$matchupsrollup$MatchupsRollup(season = "2019-20", per_mode_simple = "PerGame",def_team_id_nullable = opp_team_id)$get_data_frames()[[1]]

nba$matchupsrollup$MatchupsRollup(season = "2018-19", per_mode_simple = "PerGame", off_player_id_nullable = player_id_finder("joel embiid"), def_player_id_nullable = player_id_finder("aron baynes"))$get_data_frames()[[1]]

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
