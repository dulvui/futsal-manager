# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VisualPlayer
extends Node2D

var sim_player: SimPlayer
var ball: VisualBall

var last_update_time: float
var update_interval: float
var factor: float

var ball_pos: Vector2
var last_pos: Vector2

@onready var body: Sprite2D = $Sprites/Body
@onready var sprites: Node2D = $Sprites
@onready var label: Label = $Info/Label


func _physics_process(delta: float) -> void:
	if not Global.match_paused:
		last_update_time += delta
		factor = last_update_time / update_interval
		position = last_pos.lerp(sim_player.pos, factor)
		sprites.look_at(ball.position)


func set_up(
	p_sim_player: SimPlayer,
	p_ball: VisualBall,
	shirt_color: Color,
	p_update_interval: float,
) -> void:
	sim_player = p_sim_player
	ball = p_ball
	update_interval = p_update_interval
	last_update_time = 0.0
	factor = 1.0

	position = sim_player.pos
	last_pos = position

	body.modulate = shirt_color

	label.text = str(sim_player.player_res.nr) + " " + (sim_player.player_res.surname)


func update(p_update_interval: float) -> void:
	update_interval = p_update_interval

	last_update_time = 0
	last_pos = position


func change_player(p_sim_player: SimPlayer) -> void:
	sim_player = p_sim_player
	label.text = str(sim_player.player_res.nr) + " " + (sim_player.player_res.surname)
