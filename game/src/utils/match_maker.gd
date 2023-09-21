# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var matches:Array = []
var match_day:int = 0


func inizialize_matches() -> void:
	var teams:Array = Config.get_teams(Config.league_id).duplicate(true)
	matches = []
	match_day = 0
	
	var random_teams:Array  = teams.duplicate(true)
	random_teams.shuffle()
	
	var last_team:Dictionary = random_teams.pop_front()
	
	var home:bool = true
	
	for i in random_teams.size():
		var current_match_day:Array = []
		var matchOne:Dictionary
		if home:
			matchOne = {"home": last_team["name"],"away": random_teams[0]["name"], "result":":"}
		else:
			matchOne = {"home": random_teams[0]["name"],"away": last_team["name"], "result":":"}
		current_match_day.append(matchOne)
		
		var copy:Array = random_teams.duplicate(true)
		copy.remove_at(0)
		
		for j in range(0,(teams.size()/2) - 1):
			var home_index:int = j
			var away_index:int = - j - 1
			
			var matchTwo:Dictionary
			if home:
				matchTwo = {"home": copy[home_index]["name"],"away":copy[away_index]["name"], "result":":"}
			else:
				matchTwo = {"home": copy[away_index]["name"],"away":copy[home_index]["name"], "result":":"}
			current_match_day.append(matchTwo)
		matches.append(current_match_day)
		_shift_array(random_teams)
		home = not home

		
	# ritorno
	var temp_matches:Array = []
	for match_dayz in matches:
		var current_match_dayz:Array = []
		for matchess in match_dayz:
			var matchzz:Dictionary = {"home": matchess["away"],"away": matchess["home"], "result":":"}
			current_match_dayz.append(matchzz)
		temp_matches.append(current_match_dayz)
		
	for temp in temp_matches:
		matches.append(temp)
	
	#add to calendar
	var day:int = Config.date.day
	var month:int = Config.date.month
	
	# start with saturday
	for i in 7:
		if Config.calendar[month][i]["weekday"] == "SAT":
			day = i
			break
	
	for match_days in matches:
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
	var temp:Dictionary = array[0]
	for i in range(array.size() - 1):
		array[i] = array[i+1]
	array[array.size() - 1] = temp
