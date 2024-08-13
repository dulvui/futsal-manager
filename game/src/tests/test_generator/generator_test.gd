# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name TestGenerator
extends Node


func test() -> void:
	print("test: generator...")
	Config.reset_seed("TestSeed", 0)
	
	var generator: Generator = Generator.new()
	var world: World = generator.generate_world()
	assert(world.continents.size()  > 0)
	
	var reference_leagues: Leagues = generator.generate_leagues()
	
	# test generations 10x time
	for i: int in range(3):
		print("test: run " + str(i + 1))
		
		Config.reset_seed("TestSeed", 0)
		
		var test_leagues: Leagues = generator.generate_leagues()
		assert(test_leagues.size() == reference_leagues.size())
		assert(test_leagues[0].teams.size() == reference_leagues[0].teams.size())
		assert(test_leagues[0].teams[0].players.size() == reference_leagues[0].teams[0].players.size())
		assert(test_leagues[0].teams[0].players[0].name == reference_leagues[0].teams[0].players[0].name)
		assert(test_leagues[0].teams[1].players[1].name == reference_leagues[0].teams[1].players[1].name)
		assert(test_leagues[0].teams[2].players[2].name == reference_leagues[0].teams[2].players[2].name)
	
	print("test: generator done.")
