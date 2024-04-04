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
		
		if _should_shoot():
			shoot.emit()
			has_ball = false
		elif _should_pass():
			short_pass.emit()
			has_ball = false
		#ball.kick(direction, speed, SimBall.State.RUN)
	
func move() -> void:
	super.move()
	stamina -= 0.01

func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if  ball.players_in_shoot_trajectory <= 2:
		return Config.match_rng.randi_range(1, 100) < 20
	return false
	
	
func _should_pass() -> bool:
	return false


