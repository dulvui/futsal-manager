# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

const sim_player_scene:PackedScene = preload("res://src/match-simulator-v2/action-util-v2/actors/sim_player/sim_player.tscn")

var res_team:Team

@onready var goalkeeper:SimGoalkeeper = $SimGoalkeeper
var players:Array[SimPlayer]

var active_player:SimPlayer

var ball:SimBall
var field:SimField
var has_ball:bool
var left_half:bool

func set_up(
	p_res_team:Team,
	p_field:SimField,
	p_ball:SimBall,
	p_left_half:bool,
	color:Color,
	p_has_ball:bool,
	) -> void:
	res_team = p_res_team
	field = p_field
	ball = p_ball
	has_ball = p_has_ball
	left_half = p_left_half
	
	goalkeeper.set_up(res_team.get_goalkeeper(), field.goal_right, p_ball)
	goalkeeper.set_color(color)
	
	var pos_index: int = 0
	for player:Player in res_team.get_field_players():
		var sim_player:SimPlayer = sim_player_scene.instantiate()
		add_child(sim_player)
		
		var start_pos:Vector2 = res_team.formation.get_field_pos(field.size, pos_index, left_half)
		pos_index += 1
		
		# setup
		sim_player.set_up(player, start_pos, p_ball)
		sim_player.set_color(color)
		players.append(sim_player)
		
		# player signals
		sim_player.short_pass.connect(pass_to_random_player)
	
	# move 2 attackers to kickoff and pass to random player
	if has_ball:
		active_player = players[-1]
		active_player.set_pos(field.center + Vector2(0, -50))
		
		players[-2].set_pos(field.center + Vector2(0, 20))

func pass_to_random_player() -> void:
	var r_pos:Vector2 = players.pick_random().pos
	ball.kick(r_pos, 10, SimBall.State.PASS)
	
func update() -> void:
	# update values
	goalkeeper.update()
	for player:SimPlayer in players:
		player.update()
	# sort
	#  TODO use other array, becuase players index = position in field
	#players.sort_custom(_sort_distance_to_ball)

func act() -> void:
	goalkeeper.act()
	for player:SimPlayer in players:
		player.act()

#func _sort_distance_to_ball(a:SimPlayer, b:SimPlayer) -> bool:
	#return a.distance_to_goal < b.distance_to_goal
