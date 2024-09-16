# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Day
extends Resource

# matches by leauge/cup id
@export var matches: Dictionary
@export var market: bool
@export var weekday: String
@export var day: int
@export var month: int
@export var year: int
#@export var trainings: Array


func _init(
	p_matches: Dictionary = {},
	p_market: bool = false,
	p_weekday: String = "MON",
	p_day: int = 1,
	p_month: int = 1,
	p_year: int = 1970,
) -> void:
	matches = p_matches
	market = p_market
	weekday = p_weekday
	day = p_day
	month = p_month
	year = p_year


func add_matches(p_matches: Array, event_id: int = Config.league.id) -> void:
	if not matches.has(event_id):
		matches[event_id] = []
	(matches[event_id] as Array).append_array(p_matches)


func get_matches(event_id: int = Config.league.id) -> Array:
	if not matches.has(event_id):
		return []
	return matches[event_id]


func to_format_string() -> String:
	return weekday + " " + str(day) + " " + Const.MONTH_STRINGS[month - 1] + " " + str(year)


func is_same_day(p_day: Day) -> bool:
	if day != p_day.day:
		return false
	if month != p_day.month:
		return false
	if year != p_day.year:
		return false
	return true
