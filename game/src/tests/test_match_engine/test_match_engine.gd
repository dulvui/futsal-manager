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
	match_engine.set_up(Tests.create_mock_team(), Tests.create_mock_team(), 1234)

	match_engine.home_team.has_ball = true
	match_engine.away_team.has_ball = false
	match_engine.away_team.interception.emit()
	assert(match_engine.away_team.has_ball == true)
	assert(match_engine.home_team.has_ball == false)
	print("test: possess change done...")
