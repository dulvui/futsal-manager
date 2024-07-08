# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

@onready var test_benchmark: TestBenchmark = $TestBenchmark
@onready var test_generator: TestGenerator = $TestGenerator


func _ready() -> void:
	print("Start test suite")
	
	test_generator.test()
	
	test_benchmark.test()
	
	print("Stop test suite")
