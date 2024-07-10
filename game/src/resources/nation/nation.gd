# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Nation
extends Resource

@export var id: int
@export var name: String
@export var team: Team

func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.TEAM),
	p_name: String = "",
	p_team: Team = Team.new(),
) -> void:
	id = p_id
	name = p_name
	team = p_team

