# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _ready() -> void:
	if not Config.team:
		$VBoxContainer/Continue.hide()

func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/start/start.tscn")


func _on_Settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_Continue_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
