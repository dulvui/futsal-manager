# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Physical

@export var pace:int
@export var acceleration:int
@export var stamina:int
@export var strength:int
@export var agility:int
@export var jump:int

func _init(
	p_pace:int = 0,
	p_acceleration:int = 0,
	p_stamina:int = 0,
	p_strength:int = 0,
	p_agility:int = 0,
	p_jump:int = 0,
) -> void:
	pace = p_pace
	acceleration = p_acceleration
	stamina = p_stamina
	strength = p_strength
	agility = p_agility
	jump = p_jump
	
func average() -> int:
	var value:int = 0
	value += pace
	value += acceleration
	value += stamina
	value += strength
	value += agility
	value += jump
	return value / 6
