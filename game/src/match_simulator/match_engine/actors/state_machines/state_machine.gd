# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StateMachine


var state: StateMachineState
var previous_state: StateMachineState


func _init(p_state: StateMachineState) -> void:
	state = p_state
	state.owner = self


func update() -> void:
	state.execute()
