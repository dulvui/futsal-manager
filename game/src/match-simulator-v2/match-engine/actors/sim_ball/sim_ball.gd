# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimBall

signal corner
signal kick_in
signal goal

enum State { IDLE, PASS, CROSS, SHOOT, DRIBBLE, RUN, CORNER, KICK_IN, KICK_OFF }

const deceleration = 0.01

var state:State
var is_simulation:bool

var pos:Vector2
var speed:float
var direction:Vector2

var trajectory_polygon:PackedVector2Array
var players_in_shoot_trajectory:int
var empty_net:bool

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)

func set_up(field:SimField, p_is_simulation:bool = false) -> void:
	pos = field.center
	trajectory_polygon = PackedVector2Array()
	
	
	# disables _physics_process, if simulation
	is_simulation = p_is_simulation
	set_physics_process(not is_simulation)
	
func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	if not is_simulation:
		global_position = pos
	stop()

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

func set_corner_pos(p_pos:Vector2) -> void:
	state = State.CORNER
	set_pos(p_pos)
	
func set_kick_in_pos(p_pos:Vector2) -> void:
	state = State.KICK_IN
	set_pos(p_pos)
	
func kick_off(p_pos:Vector2) -> void:
	state = State.KICK_OFF
	set_pos(p_pos)


func is_in_field(field:SimField) -> bool:
	return Geometry2D.is_point_in_polygon(pos, field.polygon)

func check_field_bounds(field:SimField) -> void:
	if is_in_field(field):
		return
	
	# kick in
	if pos.y < 0:
		set_kick_in_pos(Vector2(pos.x, 0))
		kick_in.emit()
		return
	if pos.y > field.size.y:
		set_kick_in_pos(Vector2(pos.x, field.size.y))
		kick_in.emit()
		return
	
	if pos.x < 0 or pos.x > field.size.x:
		# TODO check if post was hit => reflect
		if field.is_goal(pos):
			kick_off(field.center)
			goal.emit()
			return
		# corner
		else:
			var corner_pos:Vector2 = field.get_corner_pos(pos)
			set_corner_pos(corner_pos)
			corner.emit()
			return
	
