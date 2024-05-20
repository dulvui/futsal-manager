# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Stadium
extends Resource

@export var name: String
@export var capacity: int
@export var year_built: int

func _init(p_name: String = "", p_capacity: int = 0, p_year_built: int = 0) -> void:
	name = p_name
	capacity = p_capacity
	year_built = p_year_built
