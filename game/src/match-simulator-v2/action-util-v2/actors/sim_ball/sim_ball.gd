# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimBall

enum State { IDLE, PASS, CROSS, SHOOT, DRIBBLE, RUN }

const deceleration = 0.01

var state:State

var pos:Vector2
var speed:float
var direction:Vector2

var trajectory_polygon:PackedVector2Array
var players_in_shoot_trajectory:int
var empty_net:bool

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)

func set_up(field_center:Vector2, p_is_simulation:bool = false) -> void:
	pos = field_center
	
	trajectory_polygon = PackedVector2Array()
	
	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)

func update() -> void:
	if speed > 0:
		speed -= deceleration
		move()
	else:
		speed = 0

func move() -> void:
	pos += direction * speed

func is_moving() -> bool:
	return speed > 0
	
func stop() -> void:
	state = State.IDLE
	speed = 0

func kick(p_destination:Vector2, force:float, type:State) -> void:
	speed = force + 0.2 # ball moves a bit faster that the force is
	direction = pos.direction_to(p_destination)
	state = type
	
