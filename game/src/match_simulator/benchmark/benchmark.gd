# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

@tool
extends Node

var matches:Array[Match]
var match_engine:MatchEngine

func _ready() -> void:
	match_engine = MatchEngine.new()
	matches = []
	create_matches(100)

func create_matches(_amount:int) -> void:
	pass

func benchmark() -> void:
	for matchz:Match in matches:
		var result_match:Match = match_engine.simulate(matchz)
		matchz.set_result(result_match.home_goals, result_match.away_goals)
