# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name TestGenerator
extends Node


func test() -> void:
	print("test: generator...")
	RngUtil.reset_seed("TestSeed", 0)
	
	var generator: Generator = Generator.new()
	var reference_world: World = generator.generate_world()
	assert(reference_world.continents.size()  > 0)
	
	# test generations 10x time
	for i: int in range(3):
		print("test: run " + str(i + 1))
		
		RngUtil.reset_seed("TestSeed", 0)
		
		var test_world: World = generator.generate_world()
		
		assert(test_world.continents.size() == reference_world.continents.size())
		
		assert(test_world.continents[0].nations.size() == reference_world.continents[0].nations.size())
		
		assert(test_world.continents[0].nations[0].leagues.size() == \
			reference_world.continents[0].nations[0].leagues.size())
		
		assert(test_world.continents[0].nations[0].leagues[0].teams.size() == \
			reference_world.continents[0].nations[0].leagues[0].teams.size())
		
		assert(test_world.continents[0].nations[0].leagues[0].teams[0].players.size() == \
			reference_world.continents[0].nations[0].leagues[0].teams[0].players.size())
		
		assert(test_world.continents[0].nations[0].leagues[0].teams[0].players[0].name == \
			reference_world.continents[0].nations[0].leagues[0].teams[0].players[0].name)
		assert(test_world.continents[0].nations[0].leagues[0].teams[0].players[1].name == \
			reference_world.continents[0].nations[0].leagues[0].teams[0].players[1].name)
		assert(test_world.continents[0].nations[0].leagues[0].teams[0].players[2].name == \
			reference_world.continents[0].nations[0].leagues[0].teams[0].players[2].name)
	
	print("test: generator done.")