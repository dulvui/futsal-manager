# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name VisualGoalkeeper

@onready var body:Sprite2D = $Sprites/Body

var sim_goal_player:SimGoalkeeper
var visual_ball:VisualBall

func _process(delta: float) -> void:
	global_position = global_position.lerp(sim_goal_player.pos, delta * Config.speed_factor * Constants.ticks_per_second)
	look_at(visual_ball.global_position)

func set_up(p_sim_goal_player:SimGoalkeeper, p_visual_ball:VisualBall, team_color:Color) -> void:
	sim_goal_player = p_sim_goal_player
	visual_ball = p_visual_ball
	global_position = sim_goal_player.pos
	body.modulate = team_color.darkened(0.5)
	
