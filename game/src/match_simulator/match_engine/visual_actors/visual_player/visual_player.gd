# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name VisualPlayer

@onready var body:Sprite2D = $Sprites/Body

var sim_player:SimPlayer
var visual_ball:VisualBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_player.pos, delta * Config.speed_factor * Constants.ticks_per_second)
	look_at(visual_ball.global_position)

func set_up(p_sim_player:SimPlayer, p_visual_ball:VisualBall, team_color:Color) -> void:
	sim_player = p_sim_player
	visual_ball = p_visual_ball
	global_position = sim_player.pos
	body.modulate = team_color