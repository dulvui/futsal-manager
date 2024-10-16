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
	Global.world = generator.generate_world()

	MatchCombinationUtil.initialize_matches()

	# set active team and league, so next match day can be found
	Global.world.active_team_id = Global.world.continents[0].nations[0].leagues[0].teams[0].id
	Global.team = Global.world.continents[0].nations[0].leagues[0].teams[0]
	Global.league = Global.world.continents[0].nations[0].leagues[0]

	print("test: searching next match day")
	while Global.world.calendar.day().get_matches().size() == 0:
		Global.world.calendar.next_day()

	print("test: calculate random results...")
	Global.world.random_results()
	print("test: benchmark done.")
