# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
extends Node2D
class_name SimGoalkeeper

@onready var body:Sprite2D = $Sprites/Body

# resources
var player_res:Player
var ball:SimBall
var field:SimField
var left_half:bool
# positions
var start_pos:Vector2
var pos:Vector2
# movements
var direction:Vector2
var destination:Vector2
var speed:float

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * Config.speed_factor * Constants.ticks_per_second)
	look_at(ball.global_position)

func set_up(
	p_player_res:Player,
	p_start_pos:Vector2,
	p_ball:SimBall,
	p_is_simulation:bool = false,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	pos = start_pos
	
	global_position = pos
	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)

func set_color(p_color:Color) -> void:
	body.modulate = p_color

func act() -> void:
	pass
	

func update() -> void:
	pass
	
