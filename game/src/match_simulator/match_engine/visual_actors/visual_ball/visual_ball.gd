# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

class_name  VisualBall
extends Node2D

var sim_ball: SimBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_ball.pos, delta * Config.speed_factor * Const.TICKS_PER_SECOND)

func set_up(p_sim_ball: SimBall) -> void:
	sim_ball = p_sim_ball
