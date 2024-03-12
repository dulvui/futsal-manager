# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Leagues
extends Resource

@export var list:Array[League]
@export var active_id:int

func _init(
		p_list:Array[League] = [],
	) -> void:
	list = p_list

func add_league(league:League) -> void:
	list.append(league)
	
func get_active() -> League:
	return get_league_by_id(active_id)
	
func get_others() -> Array[League]:
	var other_leagues:Array[League] = []
	for league:League in list:
		if league.id != active_id:
			other_leagues.append(league)
	return other_leagues
	
func get_league_by_id(league_id:int) -> League:
	for league:League in list:
		if league.id == league_id:
			return league
	return null
	
func get_leagues_by_nation(nation:Constants.Nations = 0) -> Array[League]:
	var leagues_by_nation:Array[League] = []
	for league:League in list:
		if league.nation == nation:
			leagues_by_nation.append(league)
	return leagues_by_nation
	
func get_team_by_id(team_id:int) -> Team:
	for league:League in list:
		var found_team:Team = league.get_team_by_id(team_id)
		if found_team:
			return found_team
	print("ERROR: team not found with id: " + str(team_id))
	return null

func initialize_calendars() -> void:
	for league:League in list:
		league.calendar.initialize()
		
func is_match_day(day:Day = Config.calendar().day()) -> bool:
	for league:League in list:
		if league.calendar.day(day.month, day.day).matches.size() > 0:
			return true
	return false
		
func random_results() -> void:
	for league:League in list:
		var league_calendar:Calendar = league.calendar
		for matchz:Match in league_calendar.day().matches:
			if matchz.home.id != Config.team.id and matchz.away.id != Config.team.id:
				var random_home_goals:int = randi()%10
				var random_away_goals:int = randi()%10
				matchz.set_result(random_home_goals, random_away_goals)
				league.table.add_result(matchz.home.id,random_home_goals,matchz.away.id,random_away_goals)

