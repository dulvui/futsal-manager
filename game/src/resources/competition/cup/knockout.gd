# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Knockout
extends Resource

@export var teams: Array[Team]


func _init(
	p_teams: Array[Team] = [],
) -> void:
	teams = p_teams
