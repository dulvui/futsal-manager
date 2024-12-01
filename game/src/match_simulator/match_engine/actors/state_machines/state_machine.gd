# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StateMachine


enum State {
	# no ball
	IDLE,
	MOVE,
	RECEIVE_PASS,
	# ball
	DRIBBLE,
	PASSING,
	SHOOTING,
	# defense
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
	state = State.IDLE
	team_has_ball = false
	is_touching_ball = false

	# initialize buffer
	buffer = []
	for i: int in BUFFER_SIZE:
		buffer.append(-1)
	same_state_count = 0


func update(p_team_has_ball: bool, p_is_touching_ball: bool, p_distance_to_player: float) -> void:
	team_has_ball = p_team_has_ball
	is_touching_ball = p_is_touching_ball
	distance_to_player = p_distance_to_player


func setup(p_ball: SimBall) -> void:
	ball = p_ball


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
		print("state machine stuck on state: %d"%state)

