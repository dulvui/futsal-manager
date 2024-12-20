# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TeamStateMachine
extends StateMachine

var team: SimTeam

func _init(p_field: SimField, p_team: SimTeam) -> void:
	super(p_field, TeamStateEnterField.new())
	team = p_team


func update() -> void:
	pass

