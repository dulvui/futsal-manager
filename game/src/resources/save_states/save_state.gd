# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SaveState
extends Resource

@export var id: String
@export var config_version: String
@export var config_version_history: Dictionary
@export var start_date: Dictionary
@export var generation_seed: String
@export var generation_state: int
@export var generation_gender: Const.Gender
@export var current_season: int
@export var speed_factor: int
@export var id_by_type: Dictionary
# metadata, only used for state entry
@export var meta_team_name: String
@export var meta_manager_name: String
@export var meta_team_position: String
@export var meta_last_save: Dictionary
@export var meta_game_date: Dictionary
@export var meta_create_date: Dictionary
@export var meta_is_temp: bool


func _init(
	p_generation_seed: String = "SuchDefaultSeed",
	p_generation_state: int = 0,
	p_generation_gender: Const.Gender = 0,
	p_current_season: int = 0,
	p_speed_factor: int = 1,
	p_id: String = str(int(Time.get_unix_time_from_system())),
	p_id_by_type: Dictionary = {},
	p_config_version: String = Config.CONFIG_VERSION,
	p_start_date: Dictionary = Time.get_datetime_dict_from_system(),
	p_meta_team_name: String = "",
	p_meta_manager_name: String = "",
	p_meta_team_position: String = "",
	p_meta_last_save: Dictionary = {},
	p_meta_game_date: Dictionary = {},
	p_meta_is_temp: bool = true,
) -> void:
	id = p_id
	config_version = p_config_version
	start_date = p_start_date
	generation_seed = p_generation_seed
	generation_state = p_generation_state
	generation_gender = p_generation_gender
	current_season = p_current_season
	speed_factor = p_speed_factor
	id_by_type = p_id_by_type
	meta_team_name = p_meta_team_name
	meta_manager_name = p_meta_manager_name
	meta_team_position = p_meta_team_position
	meta_last_save = p_meta_last_save
	meta_game_date = p_meta_game_date
	meta_is_temp = p_meta_is_temp


func create_dir() -> void:
	# create save state directory, if not exist yet
	var user_dir: DirAccess = DirAccess.open("user://")
	if user_dir and not user_dir.dir_exists(id):
		var err: int = user_dir.make_dir(id)
		if err != OK:
			print("error while creating save state dir")

	# save static metadata
	meta_team_name = Config.team.name
	meta_manager_name = Config.manager.get_full_name()
	meta_create_date = Time.get_datetime_dict_from_system()


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


func save_metadata() -> void:
	meta_team_position = (
		str(Config.league.table().get_position())
		+ ". "
		+ Config.league.name
	)
	meta_last_save = Time.get_datetime_dict_from_system()
	meta_game_date = Config.world.calendar.date
