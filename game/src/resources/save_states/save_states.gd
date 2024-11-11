# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveStates
extends JSONResource

var active: SaveState
# for temporary save state, when creating new save state
# becomes active_save_state, once setup is completed
var temp_state: SaveState

@export var id_list: Array[String]
@export var active_id: String


func _init(
	p_id_list: Array[String] = [],
	p_active_id: String = "",
) -> void:
	id_list = p_id_list
	active_id = p_active_id


func new_temp_state() -> void:
	var temp_id: String = RngUtil.uuid()
	temp_state = SaveState.new()
	temp_state.id = temp_id


func get_active() -> SaveState:
	# load active
	if active == null and active_id != "":
		active = load_state(active_id)
		if active == null:
			print("error while loading save state with id %s, removing it"%active_id)
			id_list.erase(active_id)
			active_id = ""


	
	if active != null:
		return active

	# create new temp state, if not created yet
	# useful when running specific scene
	# on clean game data with non-existent save state
	if not temp_state:
		print("create temp")
		new_temp_state()
	return temp_state


func get_active_path(relative_path: String = "") -> String:
	if active != null:
		return Const.SAVE_STATES_PATH + active.id + "/" + relative_path
	return ""


func make_temp_active() -> void:
	# assign metadata
	temp_state.meta_is_temp = false
	temp_state.initialize()

	# make active
	id_list.append(temp_state.id)
	active_id = temp_state.id
	active = temp_state

	new_temp_state()


func delete(state: SaveState) -> void:
	state.delete()
	id_list.erase(state.id)

	# set next value to active
	if id_list.size() > 0:
		active = load_state(id_list[-1])
	else:
		active = null


func load_state(id: String) -> SaveState:
	return ResUtil.load_resource(Const.SAVE_STATES_PATH + id + "/save_state", true)


# scan for new save states, that not exist in save_states.res yet
func scan() -> void:
	var dir: DirAccess = DirAccess.open(Const.SAVE_STATES_PATH)
	if dir:
		dir.list_dir_begin()
		var file: String = dir.get_next()
		if dir.current_is_dir():
			print("new state id found %s"%file)
			id_list.append(file)

