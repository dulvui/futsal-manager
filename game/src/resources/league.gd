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
		_nation:Nations = Nations.IT,
		_id:String = "",
		_name:String = "",
		_teams:Array[Team] = []
	) -> void:
	nation = _nation
	id = _id
	name = _name
	teams = _teams

func add_team(team:Team) -> void:
	teams.append(team)
	
func get_team_by_name(name:String) -> Team:
	for team:Team in teams:
		if team.name == name:
			return team
	return null
