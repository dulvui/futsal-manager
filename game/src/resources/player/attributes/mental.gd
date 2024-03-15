# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Mental

@export var aggression:int
@export var anticipation:int
@export var decisions:int
@export var concentration:int
@export var teamwork:int
@export var vision:int
@export var work_rate:int
@export var offensive_movement:int
@export var marking:int

func _init(
	p_aggression:int = 0,
	p_anticipation:int = 0,
	p_decisions:int = 0,
	p_concentration:int = 0,
	p_teamwork:int = 0,
	p_vision:int = 0,
	p_work_rate:int = 0,
	p_offensive_movement:int = 0,
	p_marking:int = 0,
) -> void:
	aggression = p_aggression
	anticipation = p_anticipation
	decisions = p_decisions
	concentration = p_concentration
	teamwork = p_teamwork
	vision = p_vision
	work_rate = p_work_rate
	offensive_movement = p_offensive_movement
	marking = p_marking

func average() -> int:
	var value:int = 0
	value += aggression
	value += anticipation
	value += decisions
	value += concentration
	value += teamwork
	value += vision
	value += work_rate
	value += offensive_movement
	value += marking
	return value / 9
