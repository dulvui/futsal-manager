# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	if Config.language == "ND":
		get_tree().change_scene_to_file.call_deferred("res://src/screens/start_language/start_language.tscn")
	else:
		get_tree().change_scene_to_file.call_deferred("res://src/screens/menu/menu.tscn")
