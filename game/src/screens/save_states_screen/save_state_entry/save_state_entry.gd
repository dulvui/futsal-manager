# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name SaveStateEntry

@onready var delete_dialog: ConfirmationDialog = $DeleteDialog

@onready var team: Label = $HBoxContainer/Details/Team
@onready var create_date: Label = $HBoxContainer/Dates/CreateDate
@onready var manager: Label = $HBoxContainer/Details/Manager
@onready var placement: Label = $HBoxContainer/Details/Placement
@onready var game_date: Label = $HBoxContainer/Dates/GameDate
@onready var last_save_date: Label = $HBoxContainer/Dates/LastSaveDate

var save_state:SaveState


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	team.text = save_state.meta_team_name
	manager.text = save_state.meta_manager_name
	placement.text = save_state.meta_team_position
	create_date.text = Config.calendar().format_date(save_state.meta_create_date)
	game_date.text = Config.calendar().format_date(save_state.meta_game_date)
	last_save_date.text  = Config.calendar().format_date(save_state.meta_last_save)


func set_up(p_save_state: SaveState) -> void:
	save_state = p_save_state


func _on_load_pressed() -> void:
	print("load save state with id ", save_state.id)
	Config.save_states.active_id = save_state.id
	Config.load_save_state()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_delete_pressed() -> void:
	delete_dialog.popup()


func _on_delete_dialog_confirmed() -> void:
	Config.save_states.delete(save_state)
	Config.save_config()
	Config.save_save_states()
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")
