# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualInfo
extends Control

@onready var generation_seed: LineEdit = $VBoxContainer/GenerationSeed/GenerationSeed
@onready var start_date: Label = $VBoxContainer/StartDate/StartDate


func _ready() -> void:
	generation_seed.text = Config.generation_seed
	start_date.text = Config.calendar().format_date(Config.start_date)


func _on_copy_seed_pressed() -> void:
	DisplayServer.clipboard_set(Config.generation_seed)
