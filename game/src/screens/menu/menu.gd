# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var load_game:Button = $VBoxContainer/LoadGame
@onready var continue_game: Button = $VBoxContainer/ContinueGame


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	load_game.visible = Config.active_save_state != ""
	continue_game.visible = Config.active_save_state != ""


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/start/start.tscn")


func _on_continue_game_pressed() -> void:
	Config.load_save_config()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_load_game_pressed() -> void:
	pass # Replace with function body.
