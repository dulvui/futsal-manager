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

var players_in_shoot_trajectory:int
var empty_net:bool


func set_color(p_color:Color) -> void:
	body.modulate = p_color
	

func act() -> void:
	move()
	
func move() -> void:
	super.move()
	stamina -= 0.01
	
	if has_ball:
		ball.kick(direction, speed, SimBall.State.RUN)
		
	if intercepts():
		has_ball = true
		ball.stop()



