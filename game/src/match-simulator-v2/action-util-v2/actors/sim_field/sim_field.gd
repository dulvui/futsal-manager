# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimField

@onready var sprite:Sprite2D = $Sprite

var size:Vector2
var center:Vector2

var goal_left:Vector2
var goal_left_post_upper:Vector2
var goal_left_post_lower:Vector2
var goal_left_corner_lower:Vector2
var goal_left_corner_upper:Vector2


var goal_right:Vector2
var goal_right_post_upper:Vector2
var goal_right_post_lower:Vector2
var goal_right_corner_lower:Vector2
var goal_right_corner_upper:Vector2


func set_up() -> void:
	size = sprite.texture.get_size()
	center = Vector2(size.x / 2, size.y / 2)
	
	goal_left = Vector2(0, size.y / 2)
	goal_left_post_upper = goal_left + Vector2(0, 150)
	goal_left_post_lower = goal_left + Vector2(0, -150)
	goal_left_corner_upper = Vector2(0, 0)
	goal_left_corner_lower = Vector2(0, size.y)
	
	goal_right = Vector2(size.x, size.y / 2)
	goal_right_post_upper = goal_right + Vector2(0, 150)
	goal_right_post_lower = goal_right + Vector2(0, -150)
	goal_right_corner_upper = Vector2(size.x, 0)
	goal_right_corner_lower = Vector2(size.x, size.y)

func get_post_upper(is_home:bool, home_plays_left:bool) -> Vector2:
	if is_home and home_plays_left:
		return goal_right_post_upper
	if not is_home and not home_plays_left:
		return goal_right_post_upper
	return goal_left_post_upper
	
func get_post_lower(is_home:bool, home_plays_left:bool) -> Vector2:
	if is_home and home_plays_left:
		return goal_right_post_lower
	if not is_home and not home_plays_left:
		return goal_right_post_upper
	return goal_left_post_lower
	
func get_corner_pos(ball_exit_pos:Vector2) -> Vector2:
	# start from top/left
	var corner_pos:Vector2 = Vector2(0, 0)

	if ball_exit_pos.x > size.x / 2:
		corner_pos.x = size.x # right

	if ball_exit_pos.y > size.y / 2:
		corner_pos.y = size.y # bottom

	return corner_pos

func get_goalkeeper_pos(plays_left:bool) -> Vector2:
	var pos:Vector2
	if plays_left:
		pos = goal_left
	else:
		pos = goal_right
	# move some pixels away from goal line
	pos.x = abs(pos.x - 60)
	return pos
