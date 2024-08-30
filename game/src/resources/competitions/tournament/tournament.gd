# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Tournament
extends Resource

@export var id: int
@export var table: Table
@export var calendar: Calendar
@export var pyramid_level: int
@export var name: String


func _init(
	p_id: int = -1,
	p_table: Table = Table.new(),
	p_calendar: Calendar = Calendar.new(),
	p_pyramid_level: int = -1,
	p_name: String = "",
) -> void:
	id = p_id
	table = p_table
	calendar = p_calendar
	pyramid_level = p_pyramid_level
	name = p_name
