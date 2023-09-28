# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource
class_name Team

# replace with enum
var formations:Array = ["2-2","1-2-1","1-1-2","2-1-1","1-3","3-1","4-0"]

@export var id:int
@export var name:String
@export var stadium:Stadium
@export var formation:int
@export var prestige:int
@export var budget:int
@export var salary_budget:int
@export var players:Array[Player]

class Stadium extends Resource:
	var name:String
	var capacity:int
	var year_built:int

#func _init(p_name = "p_test") -> void:
#	name = p_name
