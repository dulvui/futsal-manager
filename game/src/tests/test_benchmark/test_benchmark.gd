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
	Config.world = generator.generate_world()
	
	MatchMaker.initialize_matches()
	
	# set active team and league, so next match day can be found
	Config.world.active_team_id = Config.world.continents[0].nations[0].leagues[0].teams[0].id
	Config.team = Config.world.continents[0].nations[0].leagues[0].teams[0]
	Config.league = Config.world.continents[0].nations[0].leagues[0]
	
	print("test: searching next match day")
	while Config.world.calendar.day().get_matches().size() == 0:
		Config.world.calendar.next_day()

	print("test: calculate random results...")
	Config.world.random_results()
	print("test: benchmark done.")
