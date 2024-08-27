# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Continent
extends Resource

@export var calendar: Calendar
@export var name: String
@export var nations: Array[Nation]
@export var cup_clubs: Tournament
@export var cup_nations: Tournament


func _init(
	p_calendar: Calendar = Calendar.new(),
	p_name: String = "",
	p_nations: Array[Nation] = [],
	p_cup_clubs: Tournament = Tournament.new(),
	p_cup_nations: Tournament = Tournament.new(),
) -> void:
	calendar = p_calendar
	name = p_name
	nations = p_nations
	cup_clubs = p_cup_clubs
	cup_nations = p_cup_nations


func initialize() -> void:
	calendar.initialize()
