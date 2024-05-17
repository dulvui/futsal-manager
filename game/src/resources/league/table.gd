# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Table
extends Resource
	
@export var teams: Array[TableValues]

func _init(
		p_teams: Array[TableValues] = [],
	) -> void:
	teams = p_teams


func add_team(team: Team) -> void:
	var values: TableValues = TableValues.new()
	values.team_id = team.id
	values.team_name = team.name
	teams.append(values)


func add_result(home_id: int,home_goals: int,away_id: int,away_goals: int) -> void:
	var home: TableValues = _find_by_id(home_id)
	var away: TableValues = _find_by_id(away_id)
	
	home.goals_made += home_goals
	home.goals_against += away_goals
	away.goals_made += away_goals
	away.goals_against += home_goals
	
	if home_goals > away_goals:
		home.wins += 1
		home.points += 3
		away.lost += 1
	elif  home_goals == away_goals:
		home.draws += 1
		home.points += 1
		away.draws += 1
		away.points += 1
	else:
		away.wins += 1
		away.points += 3
		home.lost += 1
	home.games_played += 1
	away.games_played += 1


func get_position(team_id :int = Config.team.id) -> int:
	var position: int = 0
	var list: Array[TableValues] = to_sorted_array()
	while list[position].team_id != team_id:
		position += 1
	return position + 1


func to_sorted_array() -> Array:
	var sorted: Array = teams.duplicate()
	sorted.sort_custom(_point_sorter)
	return sorted


func _point_sorter(a: TableValues, b: TableValues) -> bool:
	if a.games_played == 0 and b.games_played == 0:
		return a.team_name < b.team_name
	elif a.points > b.points:
		return true
	elif a.points == b.points and a.goals_made - a.goals_against > b.goals_made - b.goals_against:
		return true
	return false


func _find_by_id(team_id: int) -> TableValues:
	for value: TableValues in teams:
		if value.team_id == team_id:
			return value
	print("ERROR while searching team in table with id: " + str(team_id))
	return null


