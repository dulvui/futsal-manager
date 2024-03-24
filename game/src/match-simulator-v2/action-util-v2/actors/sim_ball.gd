# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimBall

var pos:Vector2

func update() -> void:
	pass

func move(to:Vector2) -> void:
	pos = pos.lerp(to, Constants.lerp_weight)
	
func move_curved(to:Vector2) -> void:
	pos = pos.slerp(to, Constants.lerp_weight)

