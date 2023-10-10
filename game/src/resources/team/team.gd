# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Team

@export var id:int
@export var name:String
@export var line_up:LineUp
@export var prestige:int
@export var budget:int
@export var salary_budget:int
@export var players:Array[Player]
@export var stadium:Stadium

func create_stadium(name:String, capacity:int, year_built:int) -> void:
	stadium = Stadium.new()
	stadium.name = name
	stadium.capacity = capacity
	stadium.year_built = year_built
