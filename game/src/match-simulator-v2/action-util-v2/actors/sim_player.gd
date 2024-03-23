# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimPlayer

enum Movement { STAND, WALK, RUN, SPRINT }

# resources
var player_res:Player
# positions
var start_pos:Vector2
var pos:Vector2
var ball_pos:Vector2
# physics
var direction:Vector2
var speed:int
# fisical attributes
var stamina:float
var interception_radius:int
# state
var move_state:Movement

func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball_pos:Vector2) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball_pos = p_ball_pos

func update(p_ball_pos:Vector2) -> void:
	ball_pos = p_ball_pos
	stamina -= 0.01 # TODO depeneding on Movement, subtract more or less

func intercepts() -> bool:
	return false
