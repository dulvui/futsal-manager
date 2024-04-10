# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

signal possess

const sim_player_scene:PackedScene = preload("res://src/match-simulator-v2/match-engine/actors/sim_player/sim_player.tscn")

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
	
	goalkeeper.set_up(res_team.get_goalkeeper(), field.get_goalkeeper_pos(left_half), p_ball)
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
		sim_player.short_pass.connect(pass_to_random_player.bind(sim_player))
		sim_player.interception.connect(interception)
		sim_player.shoot.connect(shoot_on_goal)
		#sim_player.dribble.connect(pass_to_random_player)
		
	
	# move 2 attackers to kickoff and pass to random player
	if has_ball:
		active_player = players[-1]
		active_player.set_pos(field.center + Vector2(0, -10))
		active_player.state = SimPlayer.State.BALL
		
		players[-2].set_pos(field.center + Vector2(0, 80))
	else:
		press()

func update() -> void:
	# update values
	goalkeeper.update()
	for player:SimPlayer in players:
		player.update()
		# set active _player
		if player.state == SimPlayer.State.BALL:
			active_player = player


func act() -> void:
	goalkeeper.act()
	for player:SimPlayer in players:
		player.act()

func kick_off_formation() -> void:
	for player:SimPlayer in players:
		player.set_pos(player.start_pos)
	
	# move 2 attackers to kickoff and pass to random player
	if has_ball:
		active_player = players[-1]
		active_player.set_pos(field.center + Vector2(0, -50))
		
		players[-2].set_pos(field.center + Vector2(0, 20))

func interception() -> void:
	possess.emit()

func press() -> void:
	for player:SimPlayer in players:
		player.state = SimPlayer.State.PRESS

func pass_to_random_player(passing_player:SimPlayer) -> void:
	var non_active:Array[SimPlayer] = players.filter(
		func(player:SimPlayer) -> bool: return player.player_res.id != passing_player.player_res.id
	)
	var random_player:SimPlayer = non_active[Config.match_rng.randi_range(0 , non_active.size() - 1)]
	
	ball.kick(random_player.pos, 35)
	random_player.state = SimPlayer.State.RECEIVE
	random_player.stop()
	

func shoot_on_goal() -> void:
	var r_pos:Vector2
	if left_half:
		r_pos = field.goal_right
	else:
		r_pos = field.goal_left
	r_pos += Vector2(0, Config.match_rng.randi_range(field.goal_size, field.goal_size))
	ball.kick(r_pos, 100)


func _sort_distance_to_ball(a:SimPlayer, b:SimPlayer) -> bool:
	return a.distance_to_ball < b.distance_to_ball


func nearest_player_to_ball() -> SimPlayer:
	players.sort_custom(_sort_distance_to_ball)
	return players[0]
