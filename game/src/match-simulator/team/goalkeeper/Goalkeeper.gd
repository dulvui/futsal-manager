# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

var profile:Dictionary = {
	"name" : "Ronaldinho",
	"number" : 10
}

var stats:Dictionary = {
	"passes" : 0,
	"passes_success" : 0,
	"safes" : 0
}

# update to goalkeeper attributes
var attributes:Dictionary = {
	'reflexes': 4,
	'positioning': 11,
	'kicking': 13,
	'handling': 15,
	'diving': 7,
	'speed' : 7
}

func set_up(player) -> void:
	profile["name"] = player["surname"]
	profile["number"] = player["nr"]
	attributes = player["attributes"]
