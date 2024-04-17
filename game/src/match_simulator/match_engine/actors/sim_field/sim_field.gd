# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node
class_name SimField

var size:Vector2
var center:Vector2

const goal_size:int = 200
var goal_left:Vector2
var goal_right:Vector2

var polygon:PackedVector2Array

func set_up() -> void:
	#size = sprite.texture.get_size()
	size = Vector2(1200, 600)
	
	center = Vector2(size.x / 2, size.y / 2)
	
	goal_left = Vector2(0, size.y / 2)
	goal_right = Vector2(size.x, size.y / 2)
	
	polygon = PackedVector2Array()
	polygon.append(Vector2(0,0))
	polygon.append(Vector2(0,size.y))
	polygon.append(Vector2(size.x,0))
	polygon.append(size)
	


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
	if ball_pos.y < goal_left.y + (goal_size / 2) and ball_pos.y > goal_left.y - (goal_size / 2):
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
