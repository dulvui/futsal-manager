# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var scene_fade: SceneFade = %SceneFade

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	InputUtil.start_focus(self)

	# fade in effect on first open
	if Global.just_started:
		Global.just_started = false
		scene_fade.fade_in()


func _on_language_picker_language_change() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
