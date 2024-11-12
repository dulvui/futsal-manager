# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Knockout
extends JSONResource

# side a and side b of knockout graph
# final is last remaining of teams_a vs teams_b
@export var teams_a: Array[Team]
@export var teams_b: Array[Team]
# save how often teams played against each other
# handy for two leg cups
@export var match_counter: Dictionary
@export var match_amount: int


func _init(
	p_teams_a: Array[Team] = [],
	p_teams_b: Array[Team] = [],
	p_match_counter: Dictionary = {},
	p_match_amount: int = 1,
) -> void:
	teams_a = p_teams_a
	teams_b = p_teams_b
	match_counter = p_match_counter
	match_amount = p_match_amount


func set_up(p_teams: Array[Team], p_match_amount: int = 1) -> void:
	# sort teams by presitge
	p_teams.sort_custom(func(a: Team, b: Team) -> bool: return a.get_prestige() > b.get_prestige())
	match_amount = p_match_amount

	# add teams alterning to part a/b
	for i: int in p_teams.size():
		if i % 2 == 0:
			teams_a.append(p_teams[i])
		else:
			teams_b.append(p_teams[i])


func add_result(home_id: int, home_goals: int, away_id: int, away_goals: int) -> void:
	if home_goals == away_goals:
		print("error while knockout, home goals == away goals")
		return
	
	# save in match counter
	# id is always smaller id_bigger id, so it doesnt matter who plays home/away
	var match_id: String = str(min(home_id, away_id)) + "_" + str(max(home_id, away_id))
	if not match_counter.has(match_id):
		match_counter[match_id] = 1
	else:
		match_counter[match_id] += 1
	
	# only eliminate team, if necessary matches are played
	if match_counter[match_id] == match_amount:
		var elimitated_team: Team
		if home_goals > away_goals:
			elimitated_team = _find_team_by_id(away_id)
		else:
			elimitated_team = _find_team_by_id(home_id)
		teams_a.erase(elimitated_team)
		teams_b.erase(elimitated_team)


func _find_team_by_id(team_id: int) -> Team:
	for team: Team in teams_a + teams_b:
		if team.id == team_id:
			return team
	return null


