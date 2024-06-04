# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

class_name VisualGoalkeeper
extends Node2D

@onready var body: Sprite2D = $Sprites/Body
@onready var sprites: Node2D = $Sprites
@onready var label: Label = $Info/Label

var sim_goal_player: SimGoalkeeper
var visual_ball: VisualBall

var last_update_time:float
var update_interval:float
var factor: float

var last_pos:Vector2


func _physics_process(delta: float) -> void:
	last_update_time += delta
	factor = last_update_time / update_interval
	position = last_pos.lerp(sim_goal_player.pos, factor)
	
	sprites.look_at(visual_ball.global_position)


func set_up(p_sim_goal_player: SimGoalkeeper, p_visual_ball: VisualBall, team_color: Color, p_update_interval: float) -> void:
	sim_goal_player = p_sim_goal_player
	visual_ball = p_visual_ball
	
	update_interval = p_update_interval
	last_update_time = 0.0
	factor = 1.0
	
	global_position = sim_goal_player.pos
	body.modulate = team_color.darkened(0.5)
	label.text = str(sim_goal_player.player_res.nr) + " " + (sim_goal_player.player_res.surname)


func update(p_update_interval: float) -> void:
	update_interval = p_update_interval
	last_update_time = 0
	last_pos = position
