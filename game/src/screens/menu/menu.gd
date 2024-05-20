# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

@onready var load_game: Button = $VBoxContainer/LoadGame
@onready var continue_game: Button = $VBoxContainer/ContinueGame


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	
	load_game.visible = Config.save_states and Config.save_states.list.size() > 0
	continue_game.visible = Config.save_states and Config.save_states.list.size() > 0
	
	# always reset temp state in menu
	Config.save_states.reset_temp()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/start_game/start_game.tscn")


func _on_continue_game_pressed() -> void:
	Config.load_save_state()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")
