# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name  VisualBall

var sim_ball:SimBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_ball.pos, delta * Config.speed_factor * Constants.ticks_per_second)

func set_up(p_sim_ball:SimBall) -> void:
	sim_ball = p_sim_ball
