# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

@tool
class_name PlayGround
extends Node2D

@onready var visual_field: VisualField = $VisualField
@onready var visual_ball: VisualBall = $VisualBall
@onready var visual_player: VisualPlayer = $VisualPlayer

var sim_field: SimField
var sim_ball: SimBall
var sim_player: SimPlayer

var timer: Timer

func _ready() -> void:
	# intialize timer
	timer = Timer.new()
	timer.wait_time = 1.0 / (Const.TICKS_PER_SECOND * Config.speed_factor)
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	sim_field = SimField.new()
	sim_field.set_up()
	visual_field.set_up(sim_field)
	
	sim_ball = SimBall.new()
	sim_ball.set_up(sim_field)
	visual_ball.set_up(sim_ball, 0.25)
	
	sim_player = SimPlayer.new()
	sim_player.set_up(Player.new(), sim_ball)
	
	# start and move
	sim_player.set_pos(Vector2(300, 400))
	sim_player.set_destination(Vector2(400, 500))
	
	sim_player.state = SimPlayer.State.NO_BALL
	visual_player.set_up(sim_player, visual_ball, Color.RED, timer.wait_time)


func _on_timer_timeout() -> void:
	sim_ball.update()
	sim_player.move()
	visual_ball.update(timer.wait_time)
	visual_player.update(timer.wait_time)
	
