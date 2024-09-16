# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


func initialize_matches() -> void:
	for continent: Continent in Config.world.continents:
		for nation: Nation in continent.nations:
	
			# first, initialize leauge matches
			for league: League in nation.leagues:
				_initialize_club_league_matches(league)
	
			# seconldy, initialize national cups
			_initialize_club_national_cup(nation)
	
		# third, initialize continental cups
		_initialize_club_continental_cup(continent)
	
	# last, initialize continental cups
	_initialize_national_teams_world_cup()


func _initialize_club_league_matches(league: League) -> void:
	var teams: Array = league.teams.duplicate(true)
	var match_days: Array[Array]

	var random_teams: Array[Team] = teams.duplicate(true)
	RngUtil.shuffle(random_teams)

	var last_team: Team = random_teams.pop_front()

	var home: bool = true

	for i in random_teams.size():
		var current_match_day: Array = []
		var matchOne: Match
		if home:
			matchOne = Match.new(last_team, random_teams[0])
		else:
			matchOne = Match.new(random_teams[0], last_team)
		current_match_day.append(matchOne)

		var copy: Array = random_teams.duplicate(true)
		copy.remove_at(0)

		for j in range(0, (teams.size() / 2) - 1):
			var home_index: int = j
			var away_index: int = -j - 1

			var matchTwo: Match
			if home:
				matchTwo = Match.new(copy[home_index], copy[away_index])
			else:
				matchTwo = Match.new(copy[away_index], copy[home_index])
			current_match_day.append(matchTwo)

		match_days.append(current_match_day)
		_shift_array(random_teams)
		home = not home

	# second round
	var temp_match_days: Array[Array] = []
	for match_dayz: Array[Match] in match_days:
		var current_match_dayz: Array = []
		for match_dayss: Match in match_dayz:
			var matchzz: Match = Match.new(match_dayss.away, match_dayss.home)
			current_match_dayz.append(matchzz)
		temp_match_days.append(current_match_dayz)

	for temp: Array in temp_match_days:
		match_days.append(temp)

	# add to calendar
	# TODO use actual league start/end date
	# TODO allow also over 2 years
	#var day: int = Config.world.calendar.day().day
	#var month: int = Config.world.calendar.day().month
	var day: int = 0
	var month: int = 6

	# start with saturday of next week
	for i in range(8, 1, -1):
		if Config.world.calendar.day(month, i).weekday == "FRI":
			day = i
			break

	for matches: Array[Match] in match_days:
		# check if next month
		if day > Config.world.calendar.month(month).days.size() - 1:
			month += 1
			day = 0
			# start also new month with saturday
			for i in 7:
				if Config.world.calendar.day(month, i).weekday == "FRI":
					day = i
					break

		# assign match friday
		Config.world.calendar.day(month, day).add_matches( \
			matches.slice(0, matches.size() / 4), league.id)
		## assign match saturday
		day += 1
		# check if next month
		if day > Config.world.calendar.month(month).days.size() - 1:
			month += 1
			day = 0
			# start also new month with saturday
			for i in 7:
				if Config.world.calendar.day(month, i).weekday == "SAT":
					day = i
					break
		Config.world.calendar.day(month, day).add_matches( \
				matches.slice(matches.size() / 4, matches.size() / 2), league.id)
		## assign match sunday
		day += 1
		# check if next month
		if day > Config.world.calendar.month(month).days.size() - 1:
			month += 1
			day = 0
			# start also new month with saturday
			for i in 7:
				if Config.world.calendar.day(month, i).weekday == "SUN":
					day = i
					break
		Config.world.calendar.day(month, day).add_matches( \
				matches.slice(matches.size() / 2, matches.size()), league.id)
		# restart from friday
		day += 5


func _initialize_club_national_cup(_nation: Nation) -> void:
	pass


func _initialize_club_continental_cup(_continent: Continent) -> void:
	pass


func _initialize_national_teams_world_cup() -> void:
	pass


func _shift_array(array: Array) -> void:
	var temp: Team = array[0]
	for i in range(array.size() - 1):
		array[i] = array[i + 1]
	array[array.size() - 1] = temp
