# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

@onready var field:SimField = $SimField
@onready var ball:SimBall = $SimBall
@onready var home_team:SimTeam = $HomeTeam
@onready var away_team:SimTeam = $AwayTeam


func set_up(p_home_team:Team, p_away_team:Team) -> void:
	field.set_up()
	ball.set_up(field.center)
	home_team.set_up(p_home_team, field.size)
	away_team.set_up(p_away_team, field.size)
	
	coin_toss()

func update() -> void:
	ball.update()
	home_team.update(ball)
	away_team.update(ball)
	
func coin_toss() -> void:
	var coin:bool = randi() % 2 == 1
	home_team.has_ball = coin
	away_team.has_ball = not coin
