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


func _init(
		p_id:String,
		p_config_version:String,
		p_start_date:Dictionary,
		p_generation_seed:String,
		p_generation_state:int,
		p_generation_gender:Constants.Gender,
		p_current_season:int,
		p_speed_factor:int,
		p_dashboard_active_content:int,
		p_id_by_type:Dictionary,
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
