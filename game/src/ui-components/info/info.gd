# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var generation_seed:Label = $VBoxContainer/GenerationSeed/GenerationSeed
@onready var start_date:Label = $VBoxContainer/GenerationSeed/GenerationSeed


func _ready() -> void:
	generation_seed.text = Config.generation_seed
	start_date.text = CalendarUtil.format_date(Config.start_date)
