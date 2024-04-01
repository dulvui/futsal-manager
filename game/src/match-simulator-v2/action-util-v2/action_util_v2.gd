# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

@onready var field:SimField = $SimField
@onready var ball:SimBall = $SimBall
@onready var home_team:SimTeam = $HomeTeam
@onready var away_team:SimTeam = $AwayTeam


func set_up(p_home_team:Team, p_away_team:Team) -> void:
	field.set_up()
	ball.set_up(field.center)
		# set colors
	var home_color:Color = p_home_team.get_home_color()
	var away_color:Color = p_away_team.get_away_color(home_color)
	# TODO add coin toss
	home_team.set_up(p_home_team, field, ball, true, home_color, true)
	away_team.set_up(p_away_team, field, ball, false, away_color, false)
	
func update() -> void:
	ball.update()
	home_team.update()
	away_team.update()
	
	calc_distances()
	
	home_team.act()
	away_team.act()
	
func calc_distances() -> void:
	for player in home_team.players:
		calc_distance_to_goal(player, home_team.left_half)
		calc_distance_to_own_goal(player, home_team.left_half)
		calc_player_to_active_player_distance(player, home_team.active_player)
		calc_player_to_ball_distance(player)

func calc_distance_to_goal(player:SimPlayer, left_half:bool) -> void:
	if left_half:
		player.distance_to_goal = calc_distance_to(player.pos, field.goal_right)
	player.distance_to_goal = calc_distance_to(player.pos, field.goal_left)

func calc_distance_to_own_goal(player:SimPlayer, left_half:bool) -> void:
	if left_half:
		player.distance_to_own_goal = calc_distance_to(player.pos, field.goal_left)
	player.distance_to_own_goal = calc_distance_to(player.pos, field.goal_right)

func calc_player_to_active_player_distance(player:SimPlayer, active_player:SimPlayer) -> void:
	player.distance_to_active_player = calc_distance_to(player.pos, active_player.pos)
	
func calc_player_to_ball_distance(player:SimPlayer) -> void:
	player.distance_to_ball = calc_distance_to(player.pos, ball.pos)

func calc_distance_to(from:Vector2, to:Vector2) -> float:
	return from.distance_squared_to(to)
