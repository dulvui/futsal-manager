# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimField

var size:Vector2
var center:Vector2

const goal_size:int = 150
var goal_left:Vector2
var goal_right:Vector2

# y coordinates of goal posts
var upper_goal_post:int
var lower_goal_post:int

# x,y coordinates of all goal posts
var upper_goal_post_left:Vector2
var upper_goal_post_right:Vector2

var lower_goal_post_left:Vector2
var lower_goal_post_right:Vector2

var penalty_area_left_x:int
var penalty_area_right_x:int
var penalty_area_y_upper:int
var penalty_area_y_lower:int

var penalty_area_left:PackedVector2Array
var penalty_area_right:PackedVector2Array


func set_up() -> void:
	#size = sprite.texture.get_size()
	size = Vector2(1200, 600)
	
	center = Vector2(size.x / 2, size.y / 2)
	
	# goal 
	goal_left = Vector2(0, size.y / 2)
	goal_right = Vector2(size.x, size.y / 2)
	
	lower_goal_post = (size.y / 2) - (goal_size / 2)
	upper_goal_post = (size.y / 2) + (goal_size / 2)
	
	lower_goal_post_left = Vector2(0, lower_goal_post)
	upper_goal_post_left = Vector2(0, upper_goal_post)
	upper_goal_post_right = Vector2(size.x, upper_goal_post)
	upper_goal_post_right = Vector2(size.x, upper_goal_post)
	
	
	# penalty area
	var penalty_area_size:int = size.x / 8
	
	penalty_area_left_x = penalty_area_size
	penalty_area_right_x = size.x - penalty_area_size
	
	penalty_area_y_lower = lower_goal_post_left.y - penalty_area_size / 3
	penalty_area_y_upper = upper_goal_post_left.y + penalty_area_size / 3
	
	penalty_area_left = PackedVector2Array()
	penalty_area_right = PackedVector2Array()
	
	penalty_area_left.append(Vector2(0, penalty_area_y_lower))
	penalty_area_left.append(Vector2(0, penalty_area_y_upper))
	penalty_area_left.append(Vector2(penalty_area_size, penalty_area_y_lower))
	penalty_area_left.append(Vector2(penalty_area_size, penalty_area_y_upper))
	
	penalty_area_right.append(Vector2(size.x, penalty_area_y_lower))
	penalty_area_right.append(Vector2(size.x, penalty_area_y_upper))
	penalty_area_right.append(Vector2(size.x - penalty_area_size, penalty_area_y_lower))
	penalty_area_right.append(Vector2(size.x - penalty_area_size, penalty_area_y_upper))


func get_corner_pos(ball_exit_pos:Vector2) -> Vector2:
	# start from top/left
	var corner_pos:Vector2 = Vector2(0, 0)

	if ball_exit_pos.x > size.x / 2:
		corner_pos.x = size.x # right

	if ball_exit_pos.y > size.y / 2:
		corner_pos.y = size.y # bottom

	return corner_pos


func is_goal(ball_pos:Vector2) -> bool:
	return ball_pos.y > lower_goal_post and ball_pos.y < upper_goal_post


func get_goalkeeper_pos(plays_left:bool) -> Vector2:
	var pos:Vector2
	if plays_left:
		pos = goal_left
	else:
		pos = goal_right
	# move some pixels away from goal line
	pos.x = abs(pos.x - 5)
	return pos
