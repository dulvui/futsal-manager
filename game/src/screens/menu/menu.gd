# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Menu
extends Control

@onready var save_state: SaveStateEntry = $MarginContainer/VBoxContainer/SaveState

@onready var loading_screen: LoadingScreen = $LoadingScreen

@onready var load_game: Button = $MarginContainer/VBoxContainer/LoadGame
@onready var continue_game: Button = $MarginContainer/VBoxContainer/ContinueGame

@onready var version: Label = $Version


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()

	load_game.visible = Global.save_states and Global.save_states.list.size() > 0
	continue_game.visible = Global.save_states and Global.save_states.list.size() > 0

	save_state.set_up(Global.save_states.get_active())
	
	version.text = "v" + Global.version


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/setup/setup_world/setup_world.tscn")


func _on_continue_game_pressed() -> void:
	Global.load_save_state()
	LoadingUtil.start("LOADING_GAME")
	loading_screen.show()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")


func _on_loading_screen_loaded() -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")
