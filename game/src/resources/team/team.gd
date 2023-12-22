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

func _init(
	p_id:int = 0,
	p_name:String = "",
	p_line_up:LineUp = LineUp.new(),
	p_prestige:int = 0,
	p_budget:int = 0,
	p_salary_budget:int = 0,
	p_players:Array[Player] = [],
	p_stadium:Stadium = Stadium.new(),
	p_colors:Array[Color] = [Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0)]
) -> void:
	id = p_id
	name = p_name
	line_up = p_line_up
	prestige = p_prestige
	budget = p_budget
	salary_budget = p_salary_budget
	players = p_players
	stadium = p_stadium
	colors = p_colors

func create_stadium(_name:String, capacity:int, year_built:int) -> void:
	stadium = Stadium.new()
	stadium.name = _name
	stadium.capacity = capacity
	stadium.year_built = year_built
