# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name World
extends Resource

@export var name: String
@export var continents: Array[Continent]
@export var cup_clubs: Tournament
@export var cup_nations: Tournament


#func _init(
	#p_id: int = IdUtil.next_id(IdUtil.Types.TEAM),
	#p_name: String = "",
	#p_team: Team = Team.new(),
#) -> void:
	#id = p_id
	#name = p_name
	#team = p_team
