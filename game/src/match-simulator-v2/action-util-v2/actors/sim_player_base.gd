# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimPlayerBase

signal short_pass

# resources
var player_res:Player
var ball:SimBall
var field:SimField
var left_half:bool
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

func set_up(
	p_player_res:Player,
	p_start_pos:Vector2,
	p_ball:SimBall,
	p_field:SimField,
	p_left_half:bool,
	p_is_simulation:bool = false,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	field = p_field
	pos = start_pos
	
	left_half = p_left_half
	
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

func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	global_position = pos
	
func move() -> void:
	pos += direction * speed

func distance_to_own_goal() -> float:
	if left_half:
		return pos.distance_squared_to(field.goal_left)
	return pos.distance_squared_to(field.goal_right)
	
func distance_to_goal() -> float:
	if left_half:
		return pos.distance_squared_to(field.goal_right)
	return pos.distance_squared_to(field.goal_left)
