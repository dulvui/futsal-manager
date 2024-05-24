# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimTactics

enum States { DEFENSE, OFFENSE }

var formation: Formation
var positions: PackedVector2Array
var state: States
var left_half: bool


func set_up(p_formation: Formation, p_state: States, p_left_half: bool) -> void:
	formation = p_formation
	state = p_state
	left_half = p_left_half

	positions = PackedVector2Array()

	start_positions()


func update(_ball: SimBall, _state: States) -> void:
	pass


func start_positions() -> void:
	pass
