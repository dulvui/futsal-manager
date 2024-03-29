# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimGoalkeeper

@onready var sprites:Node2D = $Sprites

# resources
var player_res:Player
var ball:SimBall
var speed:float
var start_pos:Vector2
var pos:Vector2


func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)
	look_at(ball.global_position)

func set_up(p_player_res:Player, p_start_pos:Vector2, p_ball:SimBall) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	
	pos = start_pos
	
	# inital test values
	speed = 5
	
	global_position = pos

func update() -> void:
	sprites.look_at(ball.pos)
