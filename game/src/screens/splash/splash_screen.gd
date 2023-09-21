# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

func _ready() -> void:
	if Config.language == "ND":
		get_tree().change_scene_to_file("res://src/screens/language-pick/language_picker.tscn")
	else:
		get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
