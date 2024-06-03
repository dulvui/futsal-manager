# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

class_name VisualBall
extends Node2D

var sim_ball: SimBall


func _physics_process(delta: float) -> void:
	position = position.lerp(
		sim_ball.pos, delta * Config.speed_factor * Const.TICKS_PER_SECOND
	)
	
	print(str(position) + " - " + str(sim_ball.pos))


func set_up(p_sim_ball: SimBall) -> void:
	sim_ball = p_sim_ball
