# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStates
extends Resource

@export var list:Array[SaveState]
@export var active_id:String
# for temporary save state, when creating new save state
# becomes active_save_state, once setup is completed
@export var temp_id:String


func _init(
		p_list:Array[SaveState] = [],
		p_active_id:String = "",
	) -> void:
	list = p_list
	active_id = p_active_id


func new_temp_state() -> void:
	temp_id = str(int(Time.get_unix_time_from_system()))
	print("temp_id: ",temp_id)


func get_active() -> SaveState:
	for state:SaveState in list:
		if state.id == active_id:
			return state
	var state:SaveState = SaveState.new()
	state.id = active_id
	list.append(state) 
	temp_id = ""
	return state


func get_active_path(relative_path:String = "") -> String:
	if get_active():
		return "user://" + get_active().id + "/" + relative_path
	return ""


func make_temp_active() -> void:
	# create save state directory, if not exist yet
	var user_dir:DirAccess = DirAccess.open("user://")
	if not user_dir.dir_exists(temp_id):
		active_id = temp_id
		var err:int = user_dir.make_dir(active_id)
		if err != OK:
			print("error while creating save state dir")
