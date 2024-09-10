# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStates
extends Resource

@export var list: Array[SaveState]
@export var active_id: String
# for temporary save state, when creating new save state
# becomes active_save_state, once setup is completed
@export var temp_state: SaveState


func _init(
	p_list: Array[SaveState] = [],
	p_active_id: String = "",
) -> void:
	list = p_list
	active_id = p_active_id


func new_temp_state() -> void:
	var temp_id: String = str(int(Time.get_unix_time_from_system()))
	temp_state = SaveState.new()
	temp_state.id = temp_id


func get_active() -> SaveState:
	for state: SaveState in list:
		if state.id == active_id:
			return state

	return temp_state


func get_active_path(relative_path: String = "") -> String:
	if get_active():
		return "user://" + get_active().id + "/" + relative_path
	return ""


func make_temp_active() -> void:
	# assign metadata
	temp_state.meta_is_temp = false
	temp_state.save_metadata()

	# make active
	list.append(temp_state)
	active_id = temp_state.id
	temp_state.create_dir()


func delete(p_state: SaveState) -> int:
	for state: SaveState in list:
		if state.id == p_state.id:
			state.delete_dir()
			list.erase(state)
			return OK
	return ERR_FILE_NOT_FOUND
