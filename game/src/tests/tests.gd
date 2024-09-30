# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

@onready var test_calendar: TestCalendar = $TestCalendar
@onready var test_generator: TestGenerator = $TestGenerator
@onready var test_match_engine: TestMatchEngine = $TestMatchEngine
@onready var test_benchmark: TestBenchmark = $TestBenchmark
@onready var test_gameloop: TestGameloop = $TestGameloop


func _ready() -> void:
	print("Start test suite")
	
	# use new temp state
	Config.save_states.new_temp_state()
	Config.load_save_state()
	
	#test_calendar.test()
	#test_generator.test()
	#test_match_engine.test()
	#test_benchmark.test()
	test_gameloop.test()
	
	print("Stop test suite")
