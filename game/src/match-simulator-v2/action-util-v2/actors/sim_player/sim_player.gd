# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimPlayer

enum Movement { STAND, WALK, RUN, SPRINT }

enum Attack { IDLE, PASS, CROSS, SHOOT, DRIBBLE }
enum AttackNoBall { IDLE, STAY_BACK, CUT_INSIDE, SUPPORT_PLAYER }

enum Defend { WAIT, MOVE, PASS, CROSS, SHOOT, DRIBBLE }

@onready var sprites:Node2D = $Sprites

# resources
var player_res:Player
var ball:SimBall
# positions
var start_pos:Vector2
var pos:Vector2
# physics
var direction:Vector2
var speed:float
# fisical attributes
var stamina:float
var interception_radius:int #TODO reduce radius with low stamina
# state
var move_state:Movement
var has_ball:bool



func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball:SimBall) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball

func update(p_ball:SimBall) -> void:
	ball = p_ball
	stamina -= 0.01 # TODO depeneding on Movement, subtract more or less
	sprites.look_at(ball.pos)
	decide()
	move()

func intercepts() -> bool:
	if ball.is_moving() and Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		return true
	return false
	
func move() -> void:
	pos += direction * speed

func decide() -> void:
	pass
