# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TestBenchmark
extends Node

var match_engine: MatchEngine
var generator: Generator


func test() -> void:
	print("test: benchmark...")
	generator = Generator.new()
	match_engine = MatchEngine.new()
	var leagues: Leagues = generator.generate_leagues()
	
	leagues.initialize_calendars()
	
	MatchMaker.inizialize_matches(leagues)
	
	# find next match day in calendars
	for league: League in leagues.list:
		print(league.name)
		print(league.teams.size())
		while league.calendar.day().matches.size() == 0:
			league.calendar.next_day()
			

	leagues.random_results()
	print("test: benchmark done.")
