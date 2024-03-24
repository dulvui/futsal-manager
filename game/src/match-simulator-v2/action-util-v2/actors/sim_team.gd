# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimTeam

var goalkeeper:SimGoalkeepr
var players:Array[SimPlayer]

var has_ball:bool

func set_up() -> void:
	pass

func update(ball_pos:Vector2) -> void:
	for player in players:
		player.update(ball_pos)
