# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

class_name VisualMatch
extends Node2D

@onready var home_team: VisualTeam = $VisualTeamHome
@onready var away_team: VisualTeam = $VisualTeamAway
@onready var ball: VisualBall = $VisualBall
@onready var visual_field: VisualField = $VisualField

var match_engine: MatchEngine


func set_up(p_home_team: Team, p_away_team: Team, match_seed: int, update_interval: float) -> void:
	match_engine = MatchEngine.new()
	match_engine.set_up(p_home_team, p_away_team, match_seed)
	ball.set_up(match_engine.ball, update_interval)

	# get colors
	var home_color: Color = p_home_team.get_home_color()
	var away_color: Color = p_away_team.get_away_color(home_color)
	home_team.set_up(match_engine.home_team, ball, home_color, update_interval)
	away_team.set_up(match_engine.away_team, ball, away_color, update_interval)

	visual_field.set_up(match_engine.field)


func update(update_interval: float) -> void:
	match_engine.update()

	# update time intervals for position interpolations
	ball.update(update_interval)
	home_team.update(update_interval)
	away_team.update(update_interval)


func half_time() -> void:
	match_engine.half_time()
