# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Resource

enum Nations { IT }

@export var nation:Nations
@export var id:String
@export var name:String
@export var teams:Array[Team]

func _init(
		p_nation:Nations = Nations.IT,
		p_id:String = "",
		p_name:String = "",
		p_teams:Array[Team] = []
	) -> void:
	nation = p_nation
	id = p_id
	name = p_name
	teams = p_teams

func add_team(team:Team) -> void:
	teams.append(team)
	
func get_team_by_name(p_name:String) -> Team:
	for team:Team in teams:
		if team.name == p_name:
			return team
	return null
