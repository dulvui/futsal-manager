# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveState
extends Resource

@export var id:String
@export var config_version:String
@export var start_date:Dictionary
@export var generation_seed:String
@export var generation_state:int
@export var generation_gender:Constants.Gender
@export var current_season:int
@export var speed_factor:int
@export var dashboard_active_content:int
@export var id_by_type:Dictionary

@export var team_name:String


func _init(
		p_generation_seed: String = "SuchDefaultSeed",
		p_generation_state: int = 0,
		p_generation_gender: Constants.Gender = 0,
		p_current_season: int = 1,
		p_speed_factor: int = 1,
		p_dashboard_active_content: int = 0,
		p_id: String = str(int(Time.get_unix_time_from_system())),
		p_id_by_type: Dictionary = {},
		p_config_version: String = Config.config_version,
		p_start_date: Dictionary = Time.get_datetime_dict_from_system(),
		p_team_name: String = "",
	) -> void:
	id = p_id
	config_version = p_config_version
	start_date = p_start_date
	generation_seed = p_generation_seed
	generation_state = p_generation_state
	generation_gender = p_generation_gender
	current_season = p_current_season
	speed_factor = p_speed_factor
	dashboard_active_content = p_dashboard_active_content
	id_by_type = p_id_by_type
	team_name = p_team_name


func ceate_dir() -> void:
	# create save state directory, if not exist yet
	var user_dir:DirAccess = DirAccess.open("user://")
	if user_dir and not user_dir.dir_exists(id):
		var err:int = user_dir.make_dir(id)
		if err != OK:
			print("error while creating save state dir")


func delete_dir() -> void:
	var user_dir: DirAccess = DirAccess.open("user://")
	if user_dir:
		var err: int = user_dir.change_dir(id)
		if err == OK:
			# remove all files
			var file_name: String = user_dir.get_next()
			while file_name != "":
					OS.move_to_trash(ProjectSettings.globalize_path("user://" + id + "/" + file_name))
					file_name = user_dir.get_next()
		# delete folder
		user_dir.change_dir("..")
		OS.move_to_trash(ProjectSettings.globalize_path("user://" + id))
		

