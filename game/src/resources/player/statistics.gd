# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Statistics

@export var team_name: String
@export var games_played: int
@export var goals: int
@export var assists: int
@export var yellow_card: int
@export var red_card: int
@export var average_vote:float

func _init(
	p_team_name: String = "", 
	p_games_played: int = 0, 
	p_goals: int = 0, 
	p_assists: int = 0, 
	p_yellow_card: int = 0, 
	p_red_card: int = 0, 
	p_average_vote:float = 0.0, 
) -> void:
	team_name = p_team_name
	games_played = p_games_played
	goals = p_goals
	assists = p_assists
	yellow_card = p_yellow_card
	red_card = p_red_card
	average_vote = p_average_vote
