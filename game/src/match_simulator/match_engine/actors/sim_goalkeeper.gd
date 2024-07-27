# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimGoalkeeper

signal short_pass
signal interception

enum State {
	IDLE,
	# attack
	PASSING,
	#RECEIVE_PASS, TODO pass to goalie
	POSITIONING,
	# DEFENSE
	SAVE_SHOT,
}

var state: State

# resources
var player_res: Player
var ball: SimBall
var field: SimField
var left_half: bool
# positions
var start_pos: Vector2
var pos: Vector2
var last_pos: Vector2

# movements
var destination: Vector2
var speed: float

# base positions
var left_base: Vector2
var right_base: Vector2

var interception_radius: int  #TODO reduce radius with low stamina


func set_up(
	p_player_res: Player = Player.new(),
	p_ball: SimBall = SimBall.new(),
	p_field: SimField = SimField.new(),
	p_left_half: bool = false,
) -> void:
	player_res = p_player_res
	ball = p_ball
	field = p_field

	left_half = p_left_half

	start_pos = field.get_goalkeeper_pos(left_half)
	pos = start_pos
	destination = pos

	interception_radius = (player_res.attributes.goalkeeper.positioning / 2) + 10

	left_base = Vector2(field.line_left + 30, field.size.y / 2)
	right_base = Vector2(field.line_right - 30, field.size.y / 2)

	state = State.IDLE


func update(team_has_ball: bool) -> void:
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
			ball.state = SimBall.State.PASS
		State.POSITIONING:
			if team_has_ball:
				base_position()
			else:
				follow_ball()
			_move()
		State.SAVE_SHOT:
			follow_ball()
			_move()
			if block_shot():
				ball.stop()
				interception.emit()
				ball.state = SimBall.State.GOALKEEPER
				state = State.IDLE
		State.IDLE:
			if is_touching_ball():
				state = State.PASSING
			else:
				state = State.POSITIONING


func base_position() -> void:
	set_destination(start_pos)


func kick_in() -> void:
	set_pos(ball.pos)
	state = State.IDLE


func follow_ball() -> void:
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


func _move() -> void:
	if speed > 0:
		last_pos = pos
		pos = pos.move_toward(destination, speed * Const.SPEED)


func set_destination(p_destination: Vector2) -> void:
	destination = get_penalty_area_bounds(p_destination)
	speed = 15


func stop() -> void:
	speed = 0
	last_pos = pos


func is_touching_ball() -> bool:
	return ball.is_touching(pos, interception_radius)


func block_shot() -> bool:
	if is_touching_ball():
		return (
			Config.match_rng.randi_range(0, 100)
			< 69 + player_res.attributes.goalkeeper.handling * 2
		)
	return false


func set_pos(p_pos: Vector2 = pos) -> void:
	pos = p_pos
	last_pos = pos
	# reset values
	speed = 0
	destination = Vector2.INF
