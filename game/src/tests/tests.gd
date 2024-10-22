# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Tests
extends Node

@onready var test_calendar: TestCalendar = $TestCalendar
@onready var test_generator: TestGenerator = $TestGenerator
@onready var test_match_engine: TestMatchEngine = $TestMatchEngine
@onready var test_benchmark: TestBenchmark = $TestBenchmark
@onready var test_gameloop: TestGameloop = $TestGameloop
@onready var test_match_combination: TestMatchCombination = $TestMatchCombination
@onready var test_res_util: TestRestUtil = $TestResUtil


func _ready() -> void:
	print("Start test suite")

	# use new temp state
	Global.save_states.new_temp_state()
	Global.load_save_state()

	test_match_combination.test()
	test_calendar.test()
	test_generator.test()
	test_match_engine.test()
	test_benchmark.test()
	#test_gameloop.test()
	test_res_util.test()

	print("Stop test suite")


static func create_mock_team() -> Team:
	var team: Team = Team.new()
	team.set_random_colors()
	team.name = "Mock Team " + str(randi() % 100)

	for i: int in range(1, Const.LINEUP_PLAYERS_AMOUNT):
		var player: Player = Player.new()
		player.name = "Mock"
		player.surname = "Player"
		player.nr = i

		team.players.append(player)
		# assign player ids for lineup
		team.lineup_player_ids.append(player.id)

	return team


static func create_mock_player() -> Player:
	var player: Player = Player.new()

	player.name = "Mock"
	player.surname = "Player"
	player.nr = 1

	return player
