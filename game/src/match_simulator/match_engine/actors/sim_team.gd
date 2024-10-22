# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimTeam

signal interception

var res_team: Team

var goalkeeper: SimGoalkeeper
var players: Array[SimPlayer]

var ball: SimBall
var field: SimField
var has_ball: bool
var left_half: bool

var stats: MatchStatistics

# callables
var sort_x_left: Callable
var sort_x_right: Callable


func set_up(
	p_res_team: Team = Team.new(),
	p_field: SimField = SimField.new(),
	p_ball: SimBall = SimBall.new(),
	p_left_half: bool = false,
	p_has_ball: bool = false,
) -> void:
	res_team = p_res_team
	field = p_field
	ball = p_ball
	has_ball = p_has_ball
	left_half = p_left_half

	stats = MatchStatistics.new()

	goalkeeper = SimGoalkeeper.new()
	goalkeeper.set_up(res_team.get_goalkeeper(), ball, field, left_half)
	goalkeeper.short_pass.connect(pass_to_random_player)
	goalkeeper.interception.connect(_on_player_interception)

	sort_x_left = func(a: SimPlayer, b: SimPlayer) -> bool: return a.pos.x < b.pos.x
	sort_x_right = func(a: SimPlayer, b: SimPlayer) -> bool: return a.pos.x > b.pos.x

	for player: Player in res_team.get_field_players():
		var sim_player: SimPlayer = SimPlayer.new()
		# setup
		sim_player.set_up(player, ball, field)
		players.append(sim_player)
		# player signals
		sim_player.short_pass.connect(pass_to_random_player.bind(sim_player))
		sim_player.pass_received.connect(func() -> void: stats.passes_success += 1)
		sim_player.interception.connect(_on_player_interception)
		sim_player.shoot.connect(
			shoot_on_goal.bind(sim_player.player_res.attributes.technical.shooting)
		)
		#sim_player.dribble.connect(pass_to_random_player)

	set_kick_off_formation()


func defend(other_players: Array[SimPlayer]) -> void:
	goalkeeper.update(false)
	for player: SimPlayer in players:
		player.update(false)

	# assign positions
	# first sort players on x-axis
	if left_half:
		other_players.sort_custom(sort_x_left)
		players.sort_custom(sort_x_left)
	else:
		other_players.sort_custom(sort_x_right)
		players.sort_custom(sort_x_right)

	# assign destinations
	for i: int in players.size():
		# y towards goal, to block goal
		var factor: int = RngUtil.match_rng.randi_range(30, 60)
		var deviation: Vector2 = Vector2(-factor, factor)
		if other_players[i].pos.y > field.center.y:
			deviation.y -= factor * 2
		players[i].set_destination(other_players[i].pos + deviation)

	# attack ball, if not under control
	# TODO if pressing tactic, always go to ball
	if ball.state != SimBall.State.GOALKEEPER:
		var nearest_player: SimPlayer = nearest_player_to_ball()
		nearest_player.set_destination(ball.pos)
		nearest_player.state = SimPlayer.State.MOVE


func attack() -> void:
	goalkeeper.update(true)

	var nearest_player: SimPlayer = nearest_player_to_ball()
	nearest_player.set_destination(ball.pos)

	# use default formation moved on x-axis for now
	for player: SimPlayer in players:
		player.update(true)

		# set destinations
		if player.state != SimPlayer.State.DRIBBLE:
			# y towards goal, to block goal
			var factor: int = RngUtil.match_rng.randi_range(30, 60)
			var deviation: Vector2 = Vector2(-factor, factor)

			# move to other half
			if left_half:
				deviation += Vector2(400, 0)
			else:
				deviation += Vector2(-400, 0)

			player.set_destination(player.start_pos + deviation)
		else:
			player.set_destination(
				(
					player.start_pos
					+ Vector2(
						RngUtil.match_rng.randi_range(-30, 30),
						RngUtil.match_rng.randi_range(-30, 30)
					)
				)
			)


func set_kick_off_formation(change_field_side: bool = false) -> void:
	if change_field_side:
		left_half = not left_half
		goalkeeper.left_half = not goalkeeper.left_half

	var pos_index: int = 0
	for player: SimPlayer in players:
		var start_pos: Vector2 = res_team.formation.get_start_pos(field.size, pos_index, left_half)
		pos_index += 1
		player.start_pos = start_pos
		player.set_pos(start_pos)

	# move 2 attackers to kickoff and pass to random player
	if has_ball:
		players[-1].set_pos(field.center + Vector2(0, 0))
		players[-1].state = SimPlayer.State.PASSING

		players[-2].set_pos(field.center + Vector2(0, 100))


func _on_player_interception() -> void:
	print("interception")
	interception.emit()


func pass_to_random_player(passing_player: SimPlayer = null) -> void:
	var random_player: SimPlayer
	if passing_player:
		var non_active: Array[SimPlayer] = players.filter(
			func(player: SimPlayer) -> bool: return (
				player.player_res.id != passing_player.player_res.id
			)
		)
		random_player = non_active[RngUtil.match_rng.randi_range(0, non_active.size() - 1)]
	else:
		# goalkeeper pass
		random_player = players[RngUtil.match_rng.randi_range(0, players.size() - 1)]

	ball.short_pass(random_player.pos, 35)
	random_player.state = SimPlayer.State.RECEIVE_PASS
	random_player.stop()

	stats.passes += 1


func shoot_on_goal(power: float) -> void:
	var random_target: Vector2
	if left_half:
		random_target = field.goal_right
	else:
		random_target = field.goal_left

	random_target += Vector2(
		0, RngUtil.match_rng.randi_range(-field.GOAL_SIZE * 1.5, field.GOAL_SIZE * 1.5)
	)

	ball.shoot(random_target, power * RngUtil.match_rng.randi_range(2, 6))

	stats.shots += 1
	# TODO this doesnt work
	#if field.is_goal(r_pos):
	#stats.shots_on_target += 1


func _sort_distance_to_ball(a: SimPlayer, b: SimPlayer) -> bool:
	return a.distance_to_ball < b.distance_to_ball


func nearest_player_to_ball() -> SimPlayer:
	players.sort_custom(_sort_distance_to_ball)
	return players[0]
