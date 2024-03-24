# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimBall

enum State { IDLE, MOVING }

const deceleration = 0.1

@onready var sprite:Sprite2D = $Sprite

var state:State

var pos:Vector2
var speed:float
var direction:Vector2

func set_up(field_center:Vector2) -> void:
	pos = field_center
	sprite.position = pos
	

func update() -> void:
	if speed > 0:
		speed -= deceleration
		move()
	else:
		speed = 0

func move() -> void:
	pos += direction * speed
	sprite.position = pos

func is_moving() -> bool:
	return state == State.MOVING

func kick(p_destination:Vector2, force:float) -> void:
	speed = force
	direction = pos.direction_to(p_destination)
	state = State.MOVING
	
func control() -> void:
	speed = 0
	state = State.IDLE
