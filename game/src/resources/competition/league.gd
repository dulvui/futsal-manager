# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Competition

@export var table: Table
@export var teams: Array[Team]


func _init(
	p_table: Table = Table.new(),
	p_teams: Array[Team] = [],
) -> void:
	super()
	table = p_table
	teams = p_teams


func add_team(team: Team) -> void:
	teams.append(team)
	table.add_team(team)

	# sort alphabetically
	teams.sort_custom(func(a: Team, b: Team) -> bool: return a.name < b.name)


func get_team_by_id(team_id: int) -> Team:
	for team: Team in teams:
		if team.id == team_id:
			return team
	return null
