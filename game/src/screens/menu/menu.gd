# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Menu
extends Control

@onready var save_state: SaveStateEntry = $MarginContainer/VBoxContainer/SaveState

@onready var load_game: Button = $MarginContainer/VBoxContainer/LoadGame
@onready var continue_game: Button = $MarginContainer/VBoxContainer/ContinueGame

@onready var version: Label = $Version


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	load_game.visible = Config.save_states and Config.save_states.list.size() > 0
	continue_game.visible = Config.save_states and Config.save_states.list.size() > 0

	save_state.set_up(Config.save_states.get_active())
	
	version.text = "v" + Config.VERSION


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/setup/setup_world/setup_world.tscn")


func _on_continue_game_pressed() -> void:
	Config.load_save_state()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")
