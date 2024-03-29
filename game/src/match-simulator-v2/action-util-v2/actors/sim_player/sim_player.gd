# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimPlayer

@onready var body:Sprite2D = $Sprites/Body

func set_color(p_color:Color) -> void:
	body.modulate = p_color

func update() -> void:
	# TODO depeneding on Movement, subtract more or less
	stamina -= 0.01
	
	decide()
	move()
	
	if intercepts():
		#if randf() < 0.6:
			#short_pass.emit()
		#else:
			#shoot.emit()
		has_ball = true
		direction = pos.direction_to(Vector2.ZERO)
		ball.stop()
	
func move() -> void:
	super.move()
	
	if has_ball:
		ball.kick(direction, speed, SimBall.State.RUN)

func decide() -> void:
	pass
