# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

var res_team_home:Team
var res_team_away:Team

var home_team:SimTeam
var away_team:SimTeam

var ball:SimBall


func set_up(p_home_team:Team, p_away_team:Team) -> void:
	res_team_home= p_home_team
	res_team_away = p_away_team
	# TODO map res to sim team
	# momove sim players to start position
	
	# coin toss for ball
	var coin:bool = randi() % 2 == 1
	home_team.has_ball = coin
	away_team.has_ball = not coin
	
	ball = SimBall.new()

func update() -> void:
	ball.update()
	home_team.update(ball.pos)
	away_team.update(ball.pos)
	
