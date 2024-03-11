# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Resource

@export var id:int
@export var table:Table
@export var calendar:Calendar
@export var nation:Constants.Nations
@export var name:String
@export var teams:Array[Team]

func _init(
		p_id:int = IdUtil.next_id(IdUtil.Types.LEAGUE),
		p_nation:Constants.Nations = Constants.Nations.ITALY,
		p_table:Table = Table.new(),
		p_name:String = "",
		p_teams:Array[Team] = [],
		p_calendar:Calendar = Calendar.new(),
	) -> void:
	id = p_id
	nation = p_nation
	table = p_table
	name = p_name
	teams = p_teams
	calendar = p_calendar

func add_team(team:Team) -> void:
	teams.append(team)
	table.add_team(team) 
	
func get_team_by_name(p_name:String) -> Team:
	for team:Team in teams:
		if team.name == p_name:
			return team
	return null
