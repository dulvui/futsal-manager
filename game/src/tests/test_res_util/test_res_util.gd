# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TestRestUtil
extends Node


func test() -> void:
	print("test: res util...")
	var world_reference: World = Tests.create_mock_world(true)

	var world_dict: Dictionary = world_reference.to_json()

	var world: World = World.new()
	world.from_json(world_dict)

	assert(world.continents.size() == world_reference.continents.size())
	print("test: res util done.")
