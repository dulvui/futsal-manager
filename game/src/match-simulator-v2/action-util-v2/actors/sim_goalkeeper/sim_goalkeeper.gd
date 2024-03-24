# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimGoalkeeper

@onready var sprites:Node2D = $Sprites

var pos:Vector2

func update(ball:SimBall) -> void:
	sprites.look_at(ball.pos)
