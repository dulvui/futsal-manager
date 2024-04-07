# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends SimPlayerBase
class_name SimPlayer

signal interception

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
	if intercepts() and has_ball == 0:
		has_ball = 1
		ball.stop()
		interception.emit()
	
	if has_ball > 1: # if player has ball not just received
		if _should_shoot():
			has_ball = false
			shoot.emit()
		elif _should_pass():
			has_ball = false
			short_pass.emit()
		else:
			# TODO use pos from tactics
			_next_direction()
			
	if has_ball > 0:
		has_ball += 1
		stop()
	else:
		# TODO use pos from tactics
		_next_direction()
	
func move() -> void:
	super.move()
	stamina -= 0.01

func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if  ball.players_in_shoot_trajectory <= 2:
		return Config.match_rng.randi_range(1, 100) < 2
	return false
	
	
func _should_pass() -> bool:
	if distance_to_enemy < 50:
		return Config.match_rng.randi_range(1, 100) < 60
	return false

func _next_direction() -> void:
	direction = pos.direction_to(Vector2(randi_range(0, 1200), randi_range(0, 600)))
	speed = 2

