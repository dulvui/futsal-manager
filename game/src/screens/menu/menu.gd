# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Menu
extends Control

@onready var save_state: SaveStateEntry = %SaveState
@onready var save_separator: HSeparator = %SaveSeparator
@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready var load_game: Button = %LoadGame
@onready var continue_game: Button = %ContinueGame
@onready var new_game: Button = %NewGame
@onready var exit: Button = %Exit
@onready var version: Label = %Version


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	InputUtil.start_focus(self)

	# hide exit button for iOS
	exit.visible = OS.get_name() != "iOS"

	if not Global.save_states or Global.save_states.id_list.size() == 0:
		load_game.hide()
		continue_game.hide() 
		save_separator.hide()
		InputUtil.start_focus(new_game)
	else:
		InputUtil.start_focus(continue_game)


	save_state.setup(Global.save_states.get_active())

	version.text = "v" + Global.version


func _move(direction: InputUtil.Direction) -> void:
	if direction == InputUtil.Direction.UP:
		var view_port: Viewport = get_viewport()
		if view_port.gui_get_focus_owner() == null:
			var next_focus: Control = find_next_valid_focus()
			next_focus.grab_focus()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/setup/setup_world/setup_world.tscn")


func _on_continue_game_pressed() -> void:
	Global.load_save_state()
	LoadingUtil.start("LOADING_GAME", LoadingUtil.Type.LOAD_GAME)
	loading_screen.show()


func _on_settings_pressed() -> void:
	Global.settings_screen = Settings.Screen.MENU
	get_tree().change_scene_to_file("res://src/screens/settings/settings.tscn")


func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")


func _on_loading_screen_loaded(_type: LoadingUtil.Type) -> void:
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

