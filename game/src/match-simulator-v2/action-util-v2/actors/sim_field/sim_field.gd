# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimField

@onready var sprite:Sprite2D = $Sprite

var size:Vector2
var center:Vector2

var goal_left:Vector2
var goal_right:Vector2

func set_up() -> void:
	size = sprite.texture.get_size()
	center = Vector2(size.x / 2, size.y / 2)
	
	goal_left = Vector2(0, size.y / 2)
	goal_right = Vector2(size.x, size.y / 2)
	


func is_in_field(pos:Vector2) -> bool:
	return size.x <= pos.x and pos.x >= 0 and size.y <= pos.y and pos.y >= 0
