# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimPlayer

@onready var body:Sprite2D = $Sprites/Body

# distances, calculated by actiopn util
var distance_to_goal:float
var distance_to_own_goal:float
var distance_to_active_player:float
var distance_to_ball:float
var distance_to_enemy:float


func set_color(p_color:Color) -> void:
	body.modulate = p_color
	

func act() -> void:
	move()
	
	if intercepts():
		has_ball = true
		ball.stop()
	
	if has_ball:
		short_pass.emit()
		has_ball = false
		#ball.kick(direction, speed, SimBall.State.RUN)
	
func move() -> void:
	super.move()
	stamina -= 0.01




