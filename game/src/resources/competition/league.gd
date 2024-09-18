# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name League
extends Competition

@export var teams: Array[Team]
# includes also historical tables
# tables[-1] is latest winner
@export var tables: Array[Table]


func _init(
	p_teams: Array[Team] = [],
	p_tables: Array[Table] = [Table.new()],
) -> void:
	super()
	teams = p_teams
	tables = p_tables


func table() -> Table:
	return tables[-1]


func add_team(team: Team) -> void:
	teams.append(team)
	tables[-1].add_team(team)

	# sort alphabetically
	teams.sort_custom(func(a: Team, b: Team) -> bool: return a.name < b.name)


func get_team_by_id(team_id: int) -> Team:
	for team: Team in teams:
		if team.id == team_id:
			return team
	return null
