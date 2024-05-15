# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control
class_name SaveStateEntry

@onready var team: Label = $HBoxContainer/Details/Team
@onready var create_date: Label = $HBoxContainer/Dates2/CreateDate

var save_state:SaveState

func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	create_date.text = str(save_state.start_date)
	team.text = save_state.team_name


func set_up(p_save_state: SaveState) -> void:
	save_state = p_save_state

func _on_load_pressed() -> void:
	print("load save state with id ", save_state.id)
	Config.save_states.active_id = save_state.id
	Config.load_save_state()
	get_tree().change_scene_to_file("res://src/screens/dashboard/dashboard.tscn")


func _on_delete_pressed() -> void:
	Config.save_states.delete(save_state)
	get_tree().change_scene_to_file("res://src/screens/save_states_screen/save_states_screen.tscn")
	
