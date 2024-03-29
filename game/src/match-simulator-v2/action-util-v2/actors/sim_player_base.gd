# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimPlayerBase

signal short_pass
signal shoot

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

var has_ball:bool

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)
	look_at(ball.global_position)

func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball:SimBall, p_is_simulation:bool = false) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	
	pos = start_pos
	
	# inital test values
	interception_radius = 20
	speed = 5
	
	global_position = pos

	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)
	
func intercepts() -> bool:
	if ball.is_moving() and Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		return true
	return false
	
func move() -> void:
	pos += direction * speed

