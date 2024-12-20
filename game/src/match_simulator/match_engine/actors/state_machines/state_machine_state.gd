# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name StateMachineState


var name: String
var owner: StateMachine


func execute() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	owner.previous_state = self


func change_to(new_state: StateMachineState) -> void:
	exit()
	new_state.owner = owner
	owner.set_state(new_state)

