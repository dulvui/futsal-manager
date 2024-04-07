# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimField

@onready var sprite:Sprite2D = $Sprite

var size:Vector2
var center:Vector2

const goal_size:int = 300
var goal_left:Vector2
var goal_right:Vector2


func set_up() -> void:
	size = sprite.texture.get_size()
	center = Vector2(size.x / 2, size.y / 2)
	
	goal_left = Vector2(0, size.y / 2)
	goal_right = Vector2(size.x, size.y / 2)


func get_goal_posts(left:bool) -> Array[Vector2]:
	var posts:Array[Vector2] = []
	if left:
		posts.append(goal_left + Vector2(0, goal_size / 2))
		posts.append(goal_left + Vector2(0, -goal_size / 2))
	else:
		posts.append(goal_right + Vector2(0, goal_size / 2))
		posts.append(goal_right + Vector2(0, -goal_size / 2))
	return posts
	
func get_corner_pos(ball_exit_pos:Vector2) -> Vector2:
	# start from top/left
	var corner_pos:Vector2 = Vector2(0, 0)

	if ball_exit_pos.x > size.x / 2:
		corner_pos.x = size.x # right

	if ball_exit_pos.y > size.y / 2:
		corner_pos.y = size.y # bottom

	return corner_pos
	
func is_goal(ball_pos:Vector2) -> bool:
	if ball_pos.y < goal_left.y + goal_size / 2:
		return true
	if ball_pos.y > goal_left.y - goal_size / 2:
		return true
	return false

func get_goalkeeper_pos(plays_left:bool) -> Vector2:
	var pos:Vector2
	if plays_left:
		pos = goal_left
	else:
		pos = goal_right
	# move some pixels away from goal line
	pos.x = abs(pos.x - 60)
	return pos
