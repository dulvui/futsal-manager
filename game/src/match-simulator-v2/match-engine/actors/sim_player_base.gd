# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimPlayerBase

signal short_pass
signal shoot
signal dribble

enum State {FREE, KICK_OFF, KICK_IN, CORNER}

const deceleration = 0.01

var state:State

# resources
var player_res:Player
var ball:SimBall
var field:SimField
var left_half:bool
# positions
var start_pos:Vector2
var pos:Vector2
# movements
var direction:Vector2
var destination:Vector2
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
	destination = Vector2.INF
	interception_radius = 25
	speed = 15
	has_ball = 0
	state = State.FREE

	global_position = pos
	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)
	
func update() -> void:
	if speed > 0:
		move()
	
func intercepts() -> bool:
	if Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		# TODO use player block attributes
		#return true
		return Config.match_rng.randi_range(0, 100) < 60
	return false

func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	global_position = pos
	# reset values
	speed = 0
	has_ball = 0
	destination = Vector2.INF
	
func set_destination(p_destination:Vector2) -> void:
	destination = p_destination
	direction = pos.direction_to(destination)
	# TODO use speed of attributes
	speed = 2
	
func move() -> void:
	pos += direction * speed
	speed -= deceleration
	
	if pos.distance_to(destination) < 1:
		destination = Vector2.INF
		stop()
	
func kick_off_pos() -> void:
	set_pos(start_pos)
	state = State.KICK_OFF

	
func kick_in(p_pos:Vector2) -> void:
	set_pos(p_pos)
	state = State.KICK_IN
	
func corner(p_pos:Vector2) -> void:
	set_pos(p_pos)
	state = State.CORNER

func stop() -> void:
	speed = 0
