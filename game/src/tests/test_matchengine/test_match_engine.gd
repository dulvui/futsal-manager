# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name TestMatchEngine
extends Node


func test() -> void:
	print("test: match engine...")
	
	var match_engine: MatchEngine = MatchEngine.new()
	match_engine.set_up(Team.new(), Team.new(), 1234)
	
	print("test: possess change...")
	match_engine.home_team.has_ball = true
	match_engine.away_team.has_ball = false
	match_engine.away_team.interception()
	assert(match_engine.away_team.has_ball == true)
	assert(match_engine.home_team.has_ball == false)
	print("test: possess change done...")

	print("test: match engine done.")
