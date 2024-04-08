# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name MatchEngine

signal home_goal
signal away_goal

@onready var field:SimField = $SimField
@onready var ball:SimBall = $SimBall
@onready var home_team:SimTeam = $HomeTeam
@onready var away_team:SimTeam = $AwayTeam

var home_plays_left:bool

func set_up(p_home_team:Team, p_away_team:Team, match_seed:int) -> void:
	field.set_up()
	ball.set_up(field)
	
	Config.match_rng.seed = hash(match_seed)
	Config.match_rng.state = 0
		# set colors
	var home_color:Color = p_home_team.get_home_color()
	var away_color:Color = p_away_team.get_away_color(home_color)
	# TODO add coin toss
	#home_plays_left = randi_range(0, 1) == 0
	home_plays_left = true
	
	home_team.set_up(p_home_team, field, ball, home_plays_left, home_color, true)
	away_team.set_up(p_away_team, field, ball, not home_plays_left, away_color, false)
	
func update() -> void:
	ball.update()
	ball.check_field_bounds(field)
	
	home_team.update()
	away_team.update()
	
	calc_distances()
	
	home_team.act()
	away_team.act()
	
func half_time() -> void:
	home_plays_left = not home_plays_left
	# TODO create switch side method for teams
	#home_team.set_up(p_home_team, field, ball, home_plays_left, home_color, false)
	#away_team.set_up(p_away_team, field, ball, not home_plays_left, away_color, true)

func calc_distances() -> void:
	for player in home_team.players + away_team.players:
		calc_distance_to_goal(player, home_team.left_half)
		calc_distance_to_own_goal(player, home_team.left_half)
		calc_player_to_active_player_distance(player, home_team.active_player)
		calc_player_to_ball_distance(player)
	calc_free_shoot_trajectory()

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
	return from.distance_to(to)
	
func calc_free_shoot_trajectory() -> void:
	ball.players_in_shoot_trajectory = 0
	ball.empty_net = false
	ball.trajectory_polygon.clear()
	
	ball.trajectory_polygon.clear()
	ball.trajectory_polygon.append_array(field.get_goal_posts(left_is_active_goal()))
	ball.trajectory_polygon.append(ball.pos)
	
	var goalkeeper:SimGoalkeeper
	var players:Array[SimPlayer]
	
	if home_team.has_ball:
		goalkeeper = away_team.goalkeeper
		players = away_team.players
	else:
		goalkeeper = home_team.goalkeeper
		players = home_team.players
	
	ball.empty_net = not Geometry2D.is_point_in_polygon(goalkeeper.pos, ball.trajectory_polygon)
	
	for player:SimPlayer in players:
		if Geometry2D.is_point_in_polygon(player.pos, ball.trajectory_polygon):
			ball.players_in_shoot_trajectory += 1

func left_is_active_goal() -> bool:
	if home_plays_left and home_team.has_ball:
		return false
	elif home_plays_left and away_team.has_ball:
		return true
	elif not home_plays_left and home_team.has_ball:
		return false
	#if not home_plays_left and away_team.has_ball:
		#return true
	return true

func _on_sim_ball_corner() -> void:
	if home_team.has_ball:
		away_possess()
		# TODO use corner shooter defined in tactics
		away_team.nearest_player_to_ball().corner(ball.pos)
	else:
		home_possess()
		# TODO use corner shooter defined in tactics
		home_team.nearest_player_to_ball().corner(ball.pos)


func _on_sim_ball_kick_in() -> void:
	if home_team.has_ball:
		away_possess()
		away_team.nearest_player_to_ball().kick_in(ball.pos)
	else:
		home_possess()
		home_team.nearest_player_to_ball().kick_in(ball.pos)


func _on_sim_ball_goal() -> void:
	if home_team.has_ball:
		home_goal.emit()
		away_possess()
	else:
		away_goal.emit()
		home_possess()
	# reset formation
	home_team.kick_off_formation()
	away_team.kick_off_formation()
	


func _on_home_team_possess() -> void:
	home_possess()

func _on_away_team_possess() -> void:
	away_possess()


func home_possess() -> void:
	home_team.has_ball = true
	away_team.has_ball = false
	
func away_possess() -> void:
	away_team.has_ball = true
	home_team.has_ball = false
