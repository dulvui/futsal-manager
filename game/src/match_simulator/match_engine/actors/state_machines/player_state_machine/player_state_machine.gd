# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PlayerStateMachine
extends StateMachine

var player: SimPlayer


func _init(p_field: SimField, p_player: SimPlayer) -> void:
	super(p_field, PlayerStateEnterField.new())
	player = p_player


func update() -> void:
	pass
