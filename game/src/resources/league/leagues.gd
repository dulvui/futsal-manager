# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Leagues
extends Resource

@export var list:Array[League]
@export var active_name:String

func _init(
		p_list:Array[League] = [],
	) -> void:
	list = p_list

func add_league(league:League) -> void:
	list.append(league)
	
func get_active() -> League:
	return get_league_by_name(active_name)
	
func get_others() -> Array[League]:
	var other_leagues:Array[League] = []
	for league:League in list:
		if league.name != active_name:
			other_leagues.append(league)
	return other_leagues
	
func get_league_by_name(league_name:String) -> League:
	for league:League in list:
		if league.name == league_name:
			return league
	return null
	
func get_leagues_by_nation(nation:Constants.Nations = 0) -> Array[League]:
	var leagues_by_nation:Array[League] = []
	for league:League in list:
		if league.nation == nation:
			leagues_by_nation.append(league)
	return leagues_by_nation
	
func get_team_by_name(p_name:String) -> Team:
	for league:League in list:
		var found_team:Team = league.get_team_by_name(p_name)
		if found_team:
			return found_team
	print("ERROR: team not found with name: " + p_name)
	return null

func initialize_calendars() -> void:
	for league:League in list:
		league.calendar.initialize()
		
func random_results() -> void:
	for league:League in list:
		var league_calendar:Calendar = league.calendar
		for matchz:Match in league_calendar.day().matches:
			if matchz.home.name != Config.team.name:
				var random_home_goals:int = randi()%10
				var random_away_goals:int = randi()%10
				matchz.set_result(random_home_goals, random_away_goals)
				league.table.add_result(matchz.home.name,random_home_goals,matchz.away.name,random_away_goals)

