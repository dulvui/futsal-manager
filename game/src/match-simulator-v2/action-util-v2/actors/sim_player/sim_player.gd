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
	if intercepts():
		has_ball = true
		ball.stop()
	
	if has_ball:
		if _should_shoot():
			has_ball = false
			shoot.emit()
			print("shoot")
		elif _should_pass():
			has_ball = false
			short_pass.emit()
			print("pass")
		else:
			direction = _next_direction()
			print("dribble")

	move()
	
func move() -> void:
	super.move()
	stamina -= 0.01

func _should_shoot() -> bool:
	if ball.empty_net:
		print("empty net")
		return true
	if  ball.players_in_shoot_trajectory <= 2:
		return Config.match_rng.randi_range(1, 100) < 20
	return false
	
	
func _should_pass() -> bool:
	if distance_to_enemy < 50:
		return Config.match_rng.randi_range(1, 100) < 60
	return false

func _next_direction() -> Vector2:
	return Vector2.ZERO
