# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Resource

enum Nations { IT }

@export var nation:Nations
@export var table:Table
@export var name:String
@export var teams:Array[Team]

func _init(
		p_nation:Nations = Nations.IT,
		p_table:Table = Table.new(),
		p_name:String = "",
		p_teams:Array[Team] = []
	) -> void:
	nation = p_nation
	table = p_table
	name = p_name
	teams = p_teams

func add_team(team:Team) -> void:
	teams.append(team)
	table.add_team(team) 
	
func get_team_by_name(p_name:String) -> Team:
	for team:Team in teams:
		if team.name == p_name:
			return team
	return null
