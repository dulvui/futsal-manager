# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var matches:Array[Match] = []
var match_day:int = 0


func inizialize_matches(league:League = Config.leagues.get_active()) -> void:
	var teams:Array = league.teams.duplicate(true)
	matches = []
	match_day = 0
	
	var random_teams:Array[Team]  = teams.duplicate(true)
	random_teams.shuffle()
	
	var last_team:Team = random_teams.pop_front()
	
	var home:bool = true
	
	for i in random_teams.size():
		var current_match_day:Array = []
		var matchOne:Match
		if home:
			matchOne = Match.new(last_team,random_teams[0])
		else:
			matchOne = Match.new(random_teams[0], last_team)
		current_match_day.append(matchOne)
		
		var copy:Array = random_teams.duplicate(true)
		copy.remove_at(0)
		
		for j in range(0,(teams.size()/2) - 1):
			var home_index:int = j
			var away_index:int = - j - 1
			
			var matchTwo:Match
			if home:
				matchTwo = Match.new(copy[home_index], copy[away_index])
			else:
				matchTwo = Match.new(copy[away_index], copy[home_index])
			current_match_day.append(matchTwo)
		matches.append(current_match_day)
		_shift_array(random_teams)
		home = not home

		
	# ritorno
	var temp_matches:Array[Match] = []
	for match_dayz:Array[Match] in matches:
		var current_match_dayz:Array = []
		for matchess:Match in match_dayz:
			var matchzz:Dictionary = {"home": matchess["away"],"away": matchess["home"], "result":":"}
			current_match_dayz.append(matchzz)
		temp_matches.append(current_match_dayz)
		
	for temp:Array in temp_matches:
		matches.append(temp)
	
	# TODO add to calendar
	var day:int = Config.calendar()
	var month:int = Config.date.month
	
	# start with saturday
	for i in 7:
		if Config.calendar()[month][i]["weekday"] == "SAT":
			day = i
			break
	
	for match_days:Array in matches:
		# check if next month
		if day > Config.calendar[month].size() - 1:
			month += 1
			day = 0
			# start also new month with saturday
			for i in 7:
				if Config.calendar[month][i]["weekday"] == "SAT":
					day = i
					break
		# assign match days
		Config.calendar[month][day]["matches"] = match_days
		day += 7
		
func _shift_array(array:Array) -> void:
	var temp:Team = array[0]
	for i in range(array.size() - 1):
		array[i] = array[i+1]
	array[array.size() - 1] = temp
