# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

const sim_player_scene:PackedScene = preload("res://src/match-simulator-v2/action-util-v2/actors/sim_player/sim_player.tscn")

var res_team:Team

@onready var goalkeeper:SimGoalkeeper = $SimGoalkeeper
var players:Array[SimPlayer]

var has_ball:bool
var field_size:Vector2


func set_up(p_res_team:Team, p_field_size:Vector2, p_ball:SimBall) -> void:
	res_team = p_res_team
	field_size = p_field_size
	
	goalkeeper.set_up(p_ball)
	
	for player:Player in res_team.get_field_players():
		var sim_player:SimPlayer = sim_player_scene.instantiate()
		add_child(sim_player)
		sim_player.set_up(player, Vector2(randi_range(0, field_size.x), randi_range(0, field_size.y)), p_ball)
		players.append(sim_player)
	
	

func update() -> void:
	goalkeeper.update()
	for player:SimPlayer in players:
		player.update()
