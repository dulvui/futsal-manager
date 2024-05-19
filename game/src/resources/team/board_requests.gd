# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name BoardRequests

enum Types {
	POSITION,
	NATIONAL_CUP,
	CONTINENTAL_CUP,
	WORLD_CUP,
	YOUNGSTERS,
}

@export var target: int
@export var type:Types

func _init(
	p_target: int = 0,
	p_type:Types = Types.POSITION,
) -> void:
	target = p_target
	type = p_type


