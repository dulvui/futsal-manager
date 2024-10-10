# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TestMatchEngine
extends Node


func test() -> void:
	print("test: match engine...")
	test_possess_change()
	print("test: match engine done.")


func test_possess_change() -> void:
	print("test: possess change...")
	var match_engine: MatchEngine = MatchEngine.new()
	match_engine.set_up(create_mock_team(), create_mock_team(), 1234)
	
	match_engine.home_team.has_ball = true
	match_engine.away_team.has_ball = false
	match_engine.away_team.interception()
	assert(match_engine.away_team.has_ball == true)
	assert(match_engine.home_team.has_ball == false)
	print("test: possess change done...")


func create_mock_team() -> Team:
	var team: Team = Team.new()
	team.players = [
		Player.new(),
		Player.new(),
		Player.new(),
		Player.new(),
		Player.new()
	]
	# assign player ids for lineup
	team.lineup_player_ids = [
		team.players[0].id,
		team.players[1].id,
		team.players[2].id,
		team.players[3].id,
		team.players[4].id,
	]
	return team
