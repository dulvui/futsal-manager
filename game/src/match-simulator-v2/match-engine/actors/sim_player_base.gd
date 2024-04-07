# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimPlayerBase

signal short_pass
signal shoot
signal dribble

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

# ticks player has ball, 0 means no ball
var has_ball:int

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)
	look_at(ball.global_position)

func set_up(
	p_player_res:Player,
	p_start_pos:Vector2,
	p_ball:SimBall,
	p_is_simulation:bool = false,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	pos = start_pos
	
	# inital test values
	interception_radius = 25
	speed = 15
	has_ball = 0

	global_position = pos
	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)
	
func update() -> void:
	pass
	
func intercepts() -> bool:
	if Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		# TODO use player block attributes
		return Config.match_rng.randi_range(0, 100) < 60
		#return true
	return false

func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	global_position = pos
	
func move() -> void:
	pos += direction * speed