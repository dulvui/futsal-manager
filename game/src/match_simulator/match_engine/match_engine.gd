# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MatchEngine

var field:SimField
var ball:SimBall
var home_team:SimTeam
var away_team:SimTeam

var home_plays_left:bool

var ticks:int

# for trajectory calculations 
var lower_post:Vector2
var upper_post:Vector2
var players:Array[SimPlayer]
var goalkeeper:SimGoalkeeper

# stats
var possession_counter:float

func set_up(p_home_team:Team, p_away_team:Team, match_seed:int) -> void:
	field = SimField.new()
	ball = SimBall.new()
	ball.goal_line_out.connect(_on_sim_ball_goal_line_out)
	ball.touch_line_out.connect(_on_sim_ball_touch_line_out)
	ball.goal.connect(_on_sim_ball_goal)
	
	field.set_up()
	ball.set_up(field)
	
	ticks = 0
	possession_counter = 0.0
	
	Config.match_rng.state = 0
	Config.match_rng.seed = hash(match_seed)

	home_plays_left = Config.match_rng.randi_range(0, 1) == 0
	var home_has_ball:bool = Config.match_rng.randi_range(0, 1) == 0
	
	home_team = SimTeam.new()
	home_team.set_up(p_home_team, field, ball, home_plays_left, home_has_ball)
	home_team.possess.connect(_on_home_team_possess)

	away_team = SimTeam.new()
	away_team.set_up(p_away_team, field, ball, not home_plays_left, not home_has_ball)
	away_team.possess.connect(_on_away_team_possess)


func update() -> void:
	ball.update()
	
	# defend/attack
	if home_team.has_ball:
		home_team.attack()
		away_team.defend(home_team.players)
	else:
		away_team.attack()
		home_team.defend(away_team.players)
	
	calc_distances()
	
	home_team.move()
	away_team.move()
	
	# update posession stats
	ticks += 1
	if home_team.has_ball:
		possession_counter += 1.0
	home_team.stats.possession = (possession_counter / ticks) * 100
	away_team.stats.possession = 100 - home_team.stats.possession


func simulate(matchz:Match) -> Match:
	var start_time:int = Time.get_ticks_msec()
	set_up(matchz.home, matchz.away, matchz.id)
	
	# first half
	for i:int in Constants.half_time_seconds * Constants.ticks_per_second:
		update()
	half_time()
	# second half
	for i:int in Constants.half_time_seconds * Constants.ticks_per_second:
		update()
		
	matchz.home_goals = home_team.stats.goals
	matchz.away_goals = away_team.stats.goals
	
	var end_time:int = Time.get_ticks_msec()
	print("benchmark: " + str(end_time - start_time) + " result: " + str(matchz.home_goals) + ":" + str(matchz.away_goals))
	print("shots: h%d - a%d"%[home_team.stats.shots, away_team.stats.shots])
	return matchz


func half_time() -> void:
	home_plays_left = not home_plays_left
	home_team.set_kick_off_formation(true)
	away_team.set_kick_off_formation(true)
	ball.set_pos(field.center.x, field.center.y)


func calc_distances() -> void:
	for player in home_team.players + away_team.players:
		calc_distance_to_goal(player, home_team.left_half)
		calc_distance_to_own_goal(player, home_team.left_half)
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


func calc_player_to_ball_distance(player:SimPlayer) -> void:
	player.distance_to_ball = calc_distance_to(player.pos, ball.pos)


func calc_distance_to(from:Vector2, to:Vector2) -> float:
	return from.distance_to(to)


func calc_free_shoot_trajectory() -> void:
	ball.players_in_shoot_trajectory = 0
	
	if home_team.has_ball:
		goalkeeper = away_team.goalkeeper
		players = away_team.players
	else:
		goalkeeper = home_team.goalkeeper
		players = home_team.players
	
	if left_is_active_goal():
		lower_post = field.lower_goal_post_left
		upper_post = field.upper_goal_post_left
	else:
		lower_post = field.lower_goal_post_right
		upper_post = field.upper_goal_post_right
	
	ball.empty_net = not Geometry2D.point_is_inside_triangle(goalkeeper.pos, ball.pos, lower_post, upper_post)
	
	for player:SimPlayer in players:
		if Geometry2D.point_is_inside_triangle(player.pos, ball.pos, lower_post, upper_post):
			ball.players_in_shoot_trajectory += 1


func left_is_active_goal() -> bool:
	if home_plays_left and home_team.has_ball:
		return false
	elif home_plays_left and away_team.has_ball:
		return true
	elif not home_plays_left and home_team.has_ball:
		return true
	return false


func _on_sim_ball_goal_line_out() -> void:
	# TODO create signal for corner left/right
	# for goalkeeper kick ins
	
	# check if corner kick
	if (home_team.has_ball and home_plays_left and ball.pos.x < 600) \
		or (home_team.has_ball and not home_plays_left and ball.pos.x > 600):
		set_corner(true)
	elif (away_team.has_ball and home_plays_left and ball.pos.x > 600) \
		or (home_team.has_ball and not home_plays_left and ball.pos.x < 600):
		set_corner(false)
	# goalkeeper ball
	elif ball.pos.x < 600:
		# left
		ball.set_pos(30, 300)
		set_goalkeeper_ball(home_plays_left)
	else:
		# right
		ball.set_pos(1170, 300)
		set_goalkeeper_ball(not home_plays_left)


func set_corner(home:bool) -> void:
	var nearest_player:SimPlayer
	if home:
		home_possess()
		nearest_player = home_team.nearest_player_to_ball()
		home_team.stats.corners += 1
	else:
		away_possess()
		nearest_player = away_team.nearest_player_to_ball()
		away_team.stats.corners += 1
	nearest_player.set_pos(ball.pos)
	nearest_player.short_pass.emit()


func set_goalkeeper_ball(home:bool) -> void:
	if home:
		home_possess()
		goalkeeper = home_team.goalkeeper
	else:
		away_possess()
		goalkeeper = away_team.goalkeeper
	goalkeeper.set_pos(ball.pos)


func _on_sim_ball_touch_line_out() -> void:
	var nearest_player:SimPlayer
	if home_team.has_ball:
		away_possess()
		away_team.stats.kick_ins += 1
		nearest_player = away_team.nearest_player_to_ball()
	else:
		home_possess()
		home_team.stats.kick_ins += 1
		nearest_player = home_team.nearest_player_to_ball()
	
	nearest_player.set_pos(ball.pos)
	nearest_player.short_pass.emit()


func _on_sim_ball_goal() -> void:
	if home_team.has_ball:
		home_team.stats.goals += 1
		away_possess()
	else:
		away_team.stats.goals += 1
		home_possess()
	# reset formation
	home_team.set_kick_off_formation()
	away_team.set_kick_off_formation()
	ball.set_pos(field.center.x, field.center.y)


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
