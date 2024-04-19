# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D

@onready var home_team:VisualTeam = $VisualTeamHome
@onready var away_team:VisualTeam = $VisualTeamAway
@onready var ball:VisualBall = $VisualBall

var match_engine:MatchEngine

func set_up(p_home_team:Team, p_away_team:Team, match_seed:int) -> void:
	match_engine = MatchEngine.new()
	match_engine.set_up(p_home_team,p_away_team, match_seed)
	ball.set_up(match_engine.ball)
	
	# get colors
	var home_color:Color = p_home_team.get_home_color()
	var away_color:Color = p_away_team.get_away_color(home_color)
	home_team.set_up(match_engine.home_team, ball, home_color)
	away_team.set_up(match_engine.away_team, ball, away_color)
	
func update() -> void:
	match_engine.update()
	
func half_time() -> void:
	match_engine.half_time()
	
func change_players(p_home_team:Team, p_away_team:Team) -> void:
	match_engine.chage_players(p_home_team, p_away_team)
