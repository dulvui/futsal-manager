# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Month
extends Resource

@export var days: Array[Day]
@export var name: String


func _init(
	p_name: String = "",
	p_days: Array[Day] = [],
) -> void:
	name = p_name
	days = p_days
