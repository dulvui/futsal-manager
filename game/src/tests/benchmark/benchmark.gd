# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name Benchmark

var match_engine:MatchEngine
var generator:Generator


func _ready() -> void:
	generator = Generator.new()
	match_engine = MatchEngine.new()
	var leagues:Leagues = generator.generate()
	print("Start benchmark...")
	MatchMaker.inizialize_matches(leagues)
	
	while true:
		# next day in calendar
		for league:League in leagues.list:
			league.calendar.next_day()
			print("next day")
			if league.calendar.is_match_day():
				return
		
	
	for matchz:Match in leagues.damatches:
		var result_match:Match = match_engine.simulate(matchz)
		matchz.set_result(result_match.home_goals, result_match.away_goals)
	print("Benchmark done.")
	

