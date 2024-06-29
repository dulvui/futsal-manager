# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FormationPosition
extends Resource

@export var id: int
@export var name: String
@export var description: String
@export var coordinates: Vector2

func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.PLAYER),
	p_name: String = "",
	p_description: String = "",
	p_coordinates: Vector2 = Vector2.ZERO,
	) -> void:
	id = p_id
	name = p_name
	description = p_description
	coordinates = p_coordinates
