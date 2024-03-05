# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Day
extends Resource

@export var matches:Array[Match]
@export var market:bool
@export var weekday:String
@export var day:int
@export var month:int
@export var year:int
#@export var trainings:Array

func _init(
	p_matches:Array[Match],
	p_market:bool,
	p_weekday:String,
	p_day:int,
	p_month:int,
	p_year:int,
	) -> void:
	matches = p_matches
	market = p_market
	weekday = p_weekday
	day = p_day
	month = p_month
	year = p_year
