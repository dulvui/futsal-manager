# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Competition
extends JSONResource

@export var id: int
# 1 is best, bigger is lower league
@export var pyramid_level: int
@export var name: String


func _init(
	p_id: int = IdUtil.next_id(IdUtil.Types.COMPETITION),
	p_pyramid_level: int = 1,
	p_name: String = "",
) -> void:
	id = p_id
	pyramid_level = p_pyramid_level
	name = p_name
