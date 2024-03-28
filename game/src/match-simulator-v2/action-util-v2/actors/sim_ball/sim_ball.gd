# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimBall

enum State { IDLE, MOVING }

const deceleration = 0.01

var state:State

var pos:Vector2
var speed:float
var direction:Vector2

func set_up(field_center:Vector2) -> void:
	pos = field_center
	global_position = pos
	

func update() -> void:
	if speed > 0:
		speed -= deceleration
		move()
	else:
		speed = 0

func move() -> void:
	pos += direction * speed
	global_position = pos

func is_moving() -> bool:
	return state == State.MOVING
	
func stop() -> void:
	state = State.IDLE
	speed = 0

func kick(p_destination:Vector2, force:float) -> void:
	speed = force
	direction = pos.direction_to(p_destination)
	state = State.MOVING
	
func control() -> void:
	speed = 0
	state = State.IDLE
