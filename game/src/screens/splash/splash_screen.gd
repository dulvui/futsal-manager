# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SplashScreen
extends Control

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	if Global.language:
		get_tree().change_scene_to_file.call_deferred("res://src/screens/menu/menu.tscn")
	else:
		get_tree().change_scene_to_file.call_deferred(
			"res://src/screens/setup_language/setup_language.tscn"
		)
