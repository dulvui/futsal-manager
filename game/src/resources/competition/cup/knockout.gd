# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Knockout
extends Resource

# side a and side b of knockout graph
# final is last remaining of teams_a vs teams_b
@export var teams_a: Array[Team]
@export var teams_b: Array[Team]


func _init(
	p_teams_a: Array[Team] = [],
	p_teams_b: Array[Team] = [],
) -> void:
	teams_a = p_teams_a
	teams_b = p_teams_b


func set_up(p_teams: Array[Team]) -> void:
	# sort teams by presitge
	p_teams.sort_custom(
		func(a: Team, b: Team) -> bool:
			return a.get_prestige() > b.get_prestige()
			)
	
	# add teams alterning to part a/b
	for i: int in p_teams.size():
		if i % 2 == 0:
			teams_a.append(p_teams[i])
		else:
			teams_b.append(p_teams[i])
		
	
	
