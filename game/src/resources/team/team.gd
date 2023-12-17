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
# shirt colors
# 0: home color, 1: away, 2 third color
@export var colors:Array[Color]

func create_stadium(_name:String, capacity:int, year_built:int) -> void:
	stadium = Stadium.new()
	stadium.name = _name
	stadium.capacity = capacity
	stadium.year_built = year_built
