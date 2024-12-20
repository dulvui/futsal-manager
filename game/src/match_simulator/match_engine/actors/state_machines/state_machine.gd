# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StateMachine

# state buffer with states name as key and count as value
const BUFFER_SIZE: int = 10
var buffer: Array[StateMachineState]
var same_state_count: int

var state: StateMachineState
var previous_state: StateMachineState


func _init(p_state: StateMachineState) -> void:
	state = p_state
	state.owner = self
	
	# initialize buffer
	buffer = []
	same_state_count = 0


func update() -> void:
	state.execute()


func set_state(p_state: StateMachineState) -> void:
	state = p_state
	_buffer_append()


func _buffer_append() -> void:
	if buffer[-1] == state:
		same_state_count += 1
	else:
		same_state_count = 1

	buffer.append(state)

	if buffer.size() > BUFFER_SIZE:
		buffer.pop_front()

	# if same_state_count == BUFFER_SIZE / 2
	# 	print("state machine stuck on state: %s"%State.keys()[state])


