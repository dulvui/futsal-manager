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
	var world: World = generator.generate_world()
	
	var test_leagues: Array[League] = world.continents[0].nations[0].leagues
	MatchMaker.inizialize_matches(test_leagues)
	
	# find next match day in calendars
	for league: League in test_leagues:
		print(league.name)
		print(league.teams.size())
		while world.calendar.day().get_matches().size() == 0:
			world.calendar.next_day()
			

	Config.world.random_results()
	print("test: benchmark done.")
