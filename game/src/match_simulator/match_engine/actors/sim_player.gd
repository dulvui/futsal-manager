# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimPlayer

signal interception
signal short_pass
signal shoot
#signal dribble
signal pass_received

enum State {
	IDLE,
	# attacker
	DRIBBLE,
	PASSING,
	SHOOTING,
	# supporter
	RECEIVE_PASS,
	# stay high
	MOVE,
	# GOALKEEPER
	SAVE_SHOT,
	POSITIONING,
}

var state: State

# resources
var player_res: Player
var ball: SimBall
var field: SimField
# positions
var start_pos: Vector2
var pos: Vector2
var last_pos: Vector2

# movements
var destination: Vector2
var speed: int
#TODO reduce radius with low stamina
var interception_radius: int

# distances, calculated by action util
var distance_to_goal: float
var distance_to_own_goal: float
var distance_to_ball: float
var distance_to_enemy: float

# goalkeeper properties
var is_goalkeeper: bool
var left_base: Vector2
var right_base: Vector2
var left_half: bool


func set_up(
	p_player_res: Player,
	p_ball: SimBall,
	p_field: SimField,
	p_left_half: bool,
) -> void:
	player_res = p_player_res
	ball = p_ball
	field = p_field
	left_half = p_left_half
	# initial test values
	interception_radius = 10
	
	# goalkeeper properties
	left_base = Vector2(field.line_left + 30, field.size.y / 2)
	right_base = Vector2(field.line_right - 30, field.size.y / 2)

	state = State.IDLE


func update(team_has_ball: bool) -> void:
	if is_goalkeeper:
		goalkeeper_update(team_has_ball)
	else:
		player_update(team_has_ball)


func player_update(team_has_ball: bool) -> void:
	match state:
		State.IDLE:
			if is_touching_ball():
				if team_has_ball:
					if _should_shoot():
						state = State.SHOOTING
					elif _should_pass():
						state = State.PASSING
					elif _should_dribble():
						state = State.DRIBBLE
					else:
						stop()
						ball.stop()
				else:
					interception.emit()
			else:
				state = State.MOVE
		State.RECEIVE_PASS:
			if is_touching_ball():
				pass_received.emit()
				ball.stop()
				# small movement when stopping ball
				speed = RngUtil.match_rng.randi_range(3, 7)
				ball.dribble(destination, speed)
				_move()
				state = State.IDLE
		State.DRIBBLE:
			speed = RngUtil.match_rng.randi_range(5, 20)
			ball.dribble(destination, speed)
			_move()
			state = State.IDLE
		State.PASSING:
			short_pass.emit()
			state = State.IDLE
		State.SHOOTING:
			shoot.emit()
			ball.shoot(destination, speed)
			state = State.IDLE
		State.MOVE:
			_move()
			state = State.IDLE
	# print("nr %d has ball %s state %s"%[player_res.nr, team_has_ball, State.keys()[state]])


func goalkeeper_update(team_has_ball: bool) -> void:
	if not team_has_ball and ball.state == SimBall.State.SHOOT:
		speed = player_res.attributes.goalkeeper.reflexes
		state = State.SAVE_SHOT

	# reset save, if ball is no longer in shoot state
	if state == State.SAVE_SHOT and ball.state != SimBall.State.SHOOT:
		state = State.IDLE

	match state:
		State.PASSING:
			short_pass.emit()
			state = State.IDLE
		State.POSITIONING:
			if team_has_ball:
				# back to base position
				set_destination(start_pos)
			else:
				goalkeeper_follow_ball()
			_move()
		State.SAVE_SHOT:
			goalkeeper_follow_ball()
			_move()
			if block_shot():
				ball.stop()
				interception.emit()
				state = State.IDLE
				ball.state = SimBall.State.GOALKEEPER
		State.IDLE:
			if is_touching_ball():
				state = State.PASSING
			else:
				state = State.POSITIONING



func kick_off(p_pos: Vector2) -> void:
	start_pos = p_pos
	set_pos()


func is_touching_ball() -> bool:
	return ball.is_touching(pos, interception_radius)


func is_intercepting_ball() -> bool:
	return (
		RngUtil.match_rng.randi_range(1, 100)
		< 59 + player_res.attributes.technical.interception * 2
	)


func set_pos(p_pos: Vector2 = pos) -> void:
	pos = p_pos
	last_pos = pos
	destination = pos
	# reset values
	speed = 0


func set_destination(p_destination: Vector2) -> void:
	if is_goalkeeper:
		destination = get_penalty_area_bounds(p_destination)
	else:
		destination = bound_field(p_destination)
	speed = 20


func stop() -> void:
	speed = 0
	last_pos = pos


func recover_stamina(factor: int = 1) -> void:
	player_res.recover_stamina(factor)


func goalkeeper_follow_ball() -> void:
	# only follow if in own half
	if left_half:
		if ball.pos.x < field.size.x / 2:
			set_destination(left_base + left_base.direction_to(ball.pos) * 40)
		else:
			set_destination(left_base)

	else:
		if ball.pos.x > field.size.x / 2:
			set_destination(right_base + right_base.direction_to(ball.pos) * 40)
		else:
			set_destination(right_base)


func block_shot() -> bool:
	if is_touching_ball():
		return (
			RngUtil.match_rng.randi_range(0, 100)
			< 69 + player_res.attributes.goalkeeper.handling * 2
		)
	return false


func get_penalty_area_bounds(p_pos: Vector2) -> Vector2:
	if p_pos.y > field.penalty_area_y_top + 10:
		p_pos.y = field.penalty_area_y_top + 10
	elif p_pos.y < field.penalty_area_y_bottom - 10:
		p_pos.y = field.penalty_area_y_bottom - 10

	if left_half:
		if p_pos.x > field.penalty_area_left_x + 10:
			p_pos.x = field.penalty_area_left_x + 10
		elif p_pos.x < -10:
			p_pos.x = -10
	else:
		if p_pos.x < field.penalty_area_right_x - 10:
			p_pos.x = field.penalty_area_right_x - 10
		elif p_pos.x > field.size.x + field.BORDER_SIZE + 10:
			p_pos.x = field.size.x + field.BORDER_SIZE + 10

	return p_pos


func bound_field(p_pos: Vector2) -> Vector2:
	p_pos.x = maxi(mini(int(p_pos.x), int(field.line_right)), 1)
	p_pos.y = maxi(mini(int(p_pos.y), int(field.line_bottom)), 1)
	return p_pos


func _should_dribble() -> bool:
	# check something, but for now, nothing comes to my mind
	return RngUtil.match_rng.randi_range(1, 100) > 70


func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if ball.players_in_shoot_trajectory < 2:
		return RngUtil.match_rng.randi_range(1, 100) > 95
	return RngUtil.match_rng.randi_range(1, 100) > 98


func _should_pass() -> bool:
	if distance_to_enemy < 50:
		return RngUtil.match_rng.randi_range(1, 100) < 60
	return RngUtil.match_rng.randi_range(1, 100) < 10


func _move() -> void:
	if state == State.RECEIVE_PASS:
		return

	if speed > 0:
		last_pos = pos
		pos = pos.move_toward(destination, speed * Const.SPEED)
		player_res.consume_stamina()


