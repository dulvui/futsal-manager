# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StateMachine


enum State {
	# no ball
	IDLE,
	MOVE,
	RECEIVING_PASS,
	RECEIVED_PASS,
	# ball
	DRIBBLE,
	PASSING,
	SHOOTING,
	# defense
	PRESSING,
	TACKLE,
	# goalkeeper
	SAVE_SHOT,
	POSITIONING,
}

var team_has_ball: bool
var is_touching_ball: bool
var distance_to_player: float
var ball: SimBall


# state buffer with states name as key and count as value
const BUFFER_SIZE: int = 50
var buffer: Array[int]
var same_state_count: int

var state: State:
	set = _set_state


func _init() -> void:
	team_has_ball = false
	is_touching_ball = false

	# initialize buffer
	buffer = []
	for i: int in BUFFER_SIZE:
		buffer.append(-1)
	same_state_count = 0
	
	state = State.IDLE


func setup(p_ball: SimBall) -> void:
	ball = p_ball


func update(
	p_team_has_ball: bool,
	p_is_touching_ball: bool,
	p_distance_to_player: float,
	) -> void:
	team_has_ball = p_team_has_ball
	is_touching_ball = p_is_touching_ball
	distance_to_player = p_distance_to_player
	
	match state:
		State.IDLE:
			_state_idle()
		State.RECEIVING_PASS:
			_state_receive_pass()
		State.RECEIVED_PASS:
			state = State.IDLE
		State.DRIBBLE:
			state = State.IDLE
		# State.MOVE:
		# 	state = State.IDLE
		State.PRESSING:
			if is_touching_ball:
				state = State.TACKLE
		State.TACKLE:
			state = State.IDLE
		State.PASSING:
			state = State.IDLE
		State.SHOOTING:
			state = State.IDLE
		State.TACKLE:
			state = State.IDLE
		# goal keeper
		# State.POSITIONING:
		# 	state = State.IDLE
		State.SAVE_SHOT:
				ball.stop()
				state = State.IDLE
				ball.state = SimBall.State.GOALKEEPER
	# print("nr %d has ball %s state %s"%[player_res.nr, team_has_ball, State.keys()[state]])
	
	# goalkeeper
	if not team_has_ball and ball.state == SimBall.State.SHOOT:
		state = State.SAVE_SHOT

	# reset save, if ball is no longer in shoot state
	if state == State.SAVE_SHOT and ball.state != SimBall.State.SHOOT:
		state = State.IDLE


func _state_idle() -> void:
	if is_touching_ball:
		if team_has_ball:
			if _should_shoot():
				state = State.SHOOTING
			else:
				state = State.PASSING
			# elif _should_pass():
			# 	state = State.PASSING
			# elif _should_dribble():
			# 	state = State.DRIBBLE
		else:
			state = State.TACKLE
	else:
		state = State.MOVE


func _state_receive_pass() -> void:
	if is_touching_ball:
		state = State.RECEIVED_PASS
	elif same_state_count > 12:
		state = State.IDLE


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
	if distance_to_player < 50:
		return RngUtil.match_rng.randi_range(1, 100) < 60
	return RngUtil.match_rng.randi_range(1, 100) < 10


func _set_state(p_state: State) -> void:
	state = p_state
	_buffer_append()


func _buffer_append() -> void:
	if buffer[-1] == state:
		same_state_count += 1
	else:
		same_state_count = 1

	buffer.append(state)
	buffer.pop_front()

	if same_state_count == BUFFER_SIZE / 2:
		print("state machine stuck on state: %s"%State.keys()[state])

