# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

const sim_player_scene:PackedScene = preload("res://src/match-simulator-v2/action-util-v2/actors/sim_player/sim_player.tscn")

var res_team:Team

@onready var goalkeeper:SimGoalkeeper = $SimGoalkeeper
var players:Array[SimPlayer]

var ball:SimBall
var field:SimField
var has_ball:bool


func set_up(p_res_team:Team, p_field:SimField, p_ball:SimBall, left_half:bool, color:Color) -> void:
	res_team = p_res_team
	field = p_field
	ball = p_ball
	
	if left_half:
		goalkeeper.set_up(res_team.get_goalkeeper(), field.goal_left, p_ball)
	else:
		goalkeeper.set_up(res_team.get_goalkeeper(), field.goal_right, p_ball)
	goalkeeper.set_color(color)
	
	for player:Player in res_team.get_field_players():
		var sim_player:SimPlayer = sim_player_scene.instantiate()
		add_child(sim_player)
		# TODO use correct field position
		sim_player.set_up(player, Vector2(randi_range(0, field.size.x), randi_range(0, field.size.y)), p_ball)
		sim_player.set_color(color)
		players.append(sim_player)
		# player signals
		sim_player.short_pass.connect(pass_to_random_player)
		
	
func pass_to_random_player() -> void:
	var r_pos:Vector2 = players.pick_random().pos
	ball.kick(r_pos, 10, SimBall.State.PASS)
	
func update() -> void:
	goalkeeper.update()
	for player:SimPlayer in players:
		player.update()