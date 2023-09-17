# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _ready() -> void:
	if DataSaver.team_name == null:
		$CenterContainer/VBoxContainer/Continue.hide()

func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/create-manager/create_manager.tscn")


func _on_Settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/language-pick/language_picker.tscn")


func _on_Continue_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
