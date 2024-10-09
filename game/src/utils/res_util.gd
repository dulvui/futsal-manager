# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node

# resources
var world: World
var transfers: Transfers
var inbox: Inbox
# active resources references, from world
var team: Team
var league: League
var manager: Manager
# save states
var save_states: SaveStates

# .res for binary/compressed resource data
# .tres for text resource data
var res_suffix: String = ".res"
#var res_suffix: String = ".tres"

var loading_resources_paths: Array[String]
var loaded_resources_paths: Array[String]
var progress: Array
var load_status: ResourceLoader.ThreadLoadStatus


func _process(_delta: float) -> void:
	for loading_resource_path: String in loading_resources_paths:
		load_status = ResourceLoader.load_threaded_get_status(loading_resource_path, progress)
	
		if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			if progress.size() > 0:
				print(progress[0])
	
		elif load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			# assign references after resources are loaded
			world = ResourceLoader.load_threaded_get(loading_resource_path)
			team = world.get_active_team()
			league = world.get_active_league()
			manager = team.staff.manager
			
			# add to own array, to not remove element from 
			# loading_resources_paths, while iterating
			loaded_resources_paths.append(loading_resource_path)
	
	# remove loaded paths
	for loaded_path: String in loaded_resources_paths:
		loading_resources_paths.erase(loaded_path)
	loaded_resources_paths.clear()


func load_resources() -> void:
	if ResourceLoader.exists(save_states.get_active_path("inbox" + res_suffix)):
		inbox = _load_res("inbox")
	else:
		inbox = Inbox.new()
	if ResourceLoader.exists(save_states.get_active_path("transfers" + res_suffix)):
		transfers = _load_res("transfers")
	else:
		transfers = Transfers.new()
	
	if ResourceLoader.exists(save_states.get_active_path("world" + res_suffix)):
		load_world_res("world")


func load_world_res(res_key: String) -> void:
	#var start_time: int = Time.get_ticks_msec()
	
	print("loading user://" + res_key + res_suffix)
	
	var path: String = save_states.get_active_path(res_key + res_suffix)
	
	loading_resources_paths.append(path)
	
	ResourceLoader.load_threaded_request(path, "Resource", true)


func load_save_state() -> void:
	var save_sate: SaveState = save_states.get_active()
	if save_sate:
		Config.start_date = save_sate.start_date
		Config.id_by_type = save_sate.id_by_type
		Config.current_season = save_sate.current_season
		Config.speed_factor = save_sate.speed_factor
		Config.generation_seed = save_sate.generation_seed
		Config.generation_state = save_sate.generation_state
		Config.generation_player_names = save_sate.generation_player_names
		print("config speed_factor " + str(Config.speed_factor))
		load_resources()


func save_active_state() -> void:
	print("saving save state...")
	var save_sate: SaveState = save_states.get_active()
	save_sate.start_date = Config.start_date
	save_sate.id_by_type = Config.id_by_type
	save_sate.current_season = Config.current_season
	save_sate.speed_factor = Config.speed_factor
	save_sate.generation_seed = Config.generation_seed
	save_sate.generation_state = Config.generation_state
	save_sate.generation_player_names = Config.generation_player_names

	save_sate.save_metadata()

	print("save state saved")


func save_save_states() -> void:
	ResourceSaver.save(save_states, "user://save_states" + res_suffix)


func save_resources() -> void:
	ResourceSaver.save(world, save_states.get_active_path("world" + res_suffix), ResourceSaver.FLAG_COMPRESS)
	ResourceSaver.save(inbox, save_states.get_active_path("inbox" + res_suffix), ResourceSaver.FLAG_COMPRESS)
	ResourceSaver.save(transfers, save_states.get_active_path("transfers" + res_suffix), ResourceSaver.FLAG_COMPRESS)


func _load_res(res_key: String) -> Resource:
	var start_time: int = Time.get_ticks_msec()
	
	print("loading user://" + res_key + res_suffix)
	
	var path: String = save_states.get_active_path(res_key + res_suffix)
	
	#loading_resources_paths.append(path)
	
	ResourceLoader.load_threaded_request(path, "Resource", true)
	
	var res: Resource = ResourceLoader.load_threaded_get(path)

	var load_time: int = Time.get_ticks_msec() - start_time
	print("loaded in: " + str(load_time) + " ms")
	
	return res
