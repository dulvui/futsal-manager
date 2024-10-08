# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node


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
	
		if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			# assign references after resources are loaded
			Global.world = ResourceLoader.load_threaded_get(loading_resource_path)
			Global.team = Global.world.get_active_team()
			Global.league = Global.world.get_active_league()
			Global.manager = Global.team.staff.manager
			
			# add to own array, to not remove element from 
			# loading_resources_paths, while iterating
			loaded_resources_paths.append(loading_resource_path)
	
	# remove loaded paths
	for loaded_path: String in loaded_resources_paths:
		loading_resources_paths.erase(loaded_path)
	loaded_resources_paths.clear()


func save_save_states() -> void:
	ResourceSaver.save(
		Global.save_states,
		"user://save_states" + res_suffix,
		ResourceSaver.FLAG_COMPRESS
	)


func load_save_states() -> SaveStates:
	if ResourceLoader.exists("user://save_states" + res_suffix):
		print("loading user://save_states" + res_suffix)
		return ResourceLoader.load("user://save_states" + res_suffix)
	return SaveStates.new()


func load_resources() -> void:
	if ResourceLoader.exists(Global.save_states.get_active_path("inbox" + res_suffix)):
		Global.inbox = load_resource("inbox")
	else:
		Global.inbox = Inbox.new()
	if ResourceLoader.exists(Global.save_states.get_active_path("transfers" + res_suffix)):
		Global.transfers = load_resource("transfers")
	else:
		Global.transfers = Transfers.new()
	
	if ResourceLoader.exists(Global.save_states.get_active_path("world" + res_suffix)):
		load_world_resource("world")


func load_world_resource(res_key: String) -> void:
	#var start_time: int = Time.get_ticks_msec()
	
	print("loading user://" + res_key + res_suffix)
	
	var path: String = Global.save_states.get_active_path(res_key + res_suffix)
	
	loading_resources_paths.append(path)
	
	ResourceLoader.load_threaded_request(path, "Resource", true)


func save_resource(res_key: String, resource: Resource) -> void:
	ResourceSaver.save(
		resource,
		Global.save_states.get_active_path(res_key + res_suffix),
		ResourceSaver.FLAG_COMPRESS
	)


func load_resource(res_key: String) -> Resource:
	var start_time: int = Time.get_ticks_msec()
	
	print("loading user://" + res_key + res_suffix)
	
	var path: String = Global.save_states.get_active_path(res_key + res_suffix)
	
	#loading_resources_paths.append(path)
	
	ResourceLoader.load_threaded_request(path, "Resource", true)
	
	var res: Resource = ResourceLoader.load_threaded_get(path)

	var load_time: int = Time.get_ticks_msec() - start_time
	print("loaded in: " + str(load_time) + " ms")
	
	return res
