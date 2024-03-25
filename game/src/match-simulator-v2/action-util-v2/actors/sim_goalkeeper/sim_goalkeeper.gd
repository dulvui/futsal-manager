# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimGoalkeeper

@onready var sprites:Node2D = $Sprites

var ball:SimBall

var pos:Vector2

func set_up(p_ball:SimBall) -> void:
	ball = p_ball

func update() -> void:
	sprites.look_at(ball.pos)
