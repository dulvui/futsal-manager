# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

@tool
extends EditorScript
class_name Benchmark

const match_count:int = 100

var matches:Array[Match]
var match_engine:MatchEngine
var generator:Generator


func _run() -> void:
	generator = Generator.new()
	match_engine = MatchEngine.new()
	matches = []
	var leagues:Leagues = generator.generate()
	create_matches(leagues)
	print("Start benchmark with %d matches..."%match_count)
	benchmark()
	print("Benchmark done.")
	

func create_matches(_leagus:Leagues) -> void:
	pass

func benchmark() -> void:
	for matchz:Match in matches:
		var result_match:Match = match_engine.simulate(matchz)
		matchz.set_result(result_match.home_goals, result_match.away_goals)
