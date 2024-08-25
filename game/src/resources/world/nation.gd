# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Nation
extends Resource

@export var calendar: Calendar
@export var name: String
@export var leagues: Array[League]
# TODO replace leagues with league array
#@export var leagues: Array[League]
@export var cup_clubs: Tournament

#func _init(
	#p_id: int = IdUtil.next_id(IdUtil.Types.TEAM),
	#p_name: String = "",
	#p_team: Team = Team.new(),
#) -> void:
	#id = p_id
	#name = p_name
	#team = p_team


func add_league(league: League) -> void:
	leagues.append(league)


func get_league_by_id(league_id: int) -> League:
	for league: League in leagues:
		if league.id == league_id:
			return league
	return null


func get_team_by_id(team_id: int) -> Team:
	for league: League in leagues:
		var found_team: Team = league.get_team_by_id(team_id)
		if found_team:
			return found_team
	print("ERROR: team not found with id: " + str(team_id))
	return null


func initialize_calendars() -> void:
	for league: League in leagues:
		league.calendar.initialize()


func random_results() -> void:
	var match_engine: MatchEngine = MatchEngine.new()
	for league: League in leagues:
		var league_calendar: Calendar = league.calendar
		for matchz: Match in league_calendar.day().matches:
			if matchz.home.id != Config.team.id and matchz.away.id != Config.team.id:
				var result_match: Match = match_engine.simulate(matchz)
				matchz.set_result(result_match.home_goals, result_match.away_goals)
				league.table.add_result(
					matchz.home.id, result_match.home_goals, matchz.away.id, result_match.away_goals
				)
