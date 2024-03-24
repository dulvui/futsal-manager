# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

var res_team:Team

@onready var goalkeeper:SimGoalkeepr = $SimGoalkeeper
@onready var player1:SimPlayer = $SimPlayer1
@onready var player2:SimPlayer = $SimPlayer2
@onready var player3:SimPlayer = $SimPlayer3
@onready var player4:SimPlayer = $SimPlayer4


var has_ball:bool
var field_size:Vector2


func set_up(p_res_team:Team, p_field_size:Vector2) -> void:
	res_team = p_res_team
	field_size = p_field_size

func update(ball:SimBall) -> void:
	goalkeeper.update(ball)
	player1.update(ball)
	player2.update(ball)
	player3.update(ball)
	player4.update(ball)
	
