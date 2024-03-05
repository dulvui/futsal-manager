# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Match
extends Resource

@export var matches:Array
@export var market:bool
@export var weekday:String
@export var day:int
@export var month:int
@export var year:int
#@export var trainings:Array

func _init(
		p_nationality:String = "",
		p_name:String = "",
		p_surname:String = "",
		p_prestige:int = 10
	) -> void:
	nationality = p_nationality
	name = p_name
	surname = p_surname
	prestige = p_prestige

func get_full_name() -> String:
	return name + " " + surname
