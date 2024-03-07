# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Match
extends Resource

@export var home:Team
@export var away:Team
@export var home_goals:int
@export var away_goals:int

func _init(
	p_home:Team = Team.new(),
	p_away:Team = Team.new(),
	p_home_goals:int = -1,
	p_away_goals:int = -1,
	) -> void:
	home = p_home
	away = p_away
	home_goals = p_home_goals
	away_goals = p_away_goals

func get_result() -> String:
	if home_goals == -1 and away_goals == -1:
		return ""
	return str(home_goals) + " : " + str(away_goals)
