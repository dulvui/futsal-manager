# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

@onready var benchmark: TestBenchmark = $Benchmark
@onready var generator_test: TestGenerator = $GeneratorTest


func _ready() -> void:
	generator_test.test()
	benchmark.test()
