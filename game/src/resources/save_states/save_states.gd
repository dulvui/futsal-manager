# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStates
extends JSONResource

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
	
	new_temp_state()


func delete(state: SaveState) -> void:
	state.delete_dir()
	list.erase(state)
	
	# set next value to active
	if list.size() > 0:
		active_id = list[-1].id
	else:
		active_id = ""
