# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimField

const goal_size:int = 150
const border_size:int = 100
const width:int = 1200
const height:int = 600

# don't use Rect2, to keep simple and human-readable names for coordinates 
var size:Vector2 # with borders
var center:Vector2
var line_top:int
var line_bottom:int
var line_left:int
var line_right:int

var goal_left:Vector2
var goal_right:Vector2

# y coordinates of goal posts
var goal_post_top:int
var goal_post_bottom:int

# x,y coordinates of all goal posts
var goal_post_top_left:Vector2
var goal_post_top_right:Vector2

var goal_post_bottom_left:Vector2
var goal_post_bottom_right:Vector2

var penalty_area_left_x:int
var penalty_area_right_x:int
var penalty_area_y_top:int
var penalty_area_y_bottom:int

var penalty_area_left:PackedVector2Array
var penalty_area_right:PackedVector2Array


func set_up() -> void:
	#size = sprite.texture.get_size()
	size = Vector2(width + border_size * 2, height + border_size * 2)
	
	center = Vector2(size.x / 2, size.y / 2)
	
	line_top = border_size
	line_bottom = line_top + height
	line_left = border_size
	line_right = line_left + width
	
	# goal 
	goal_left = Vector2(line_left, size.y / 2)
	goal_right = Vector2(line_right, size.y / 2)
	
	goal_post_bottom = (size.y / 2) - (goal_size / 2)
	goal_post_top = (size.y / 2) + (goal_size / 2)
	
	goal_post_top_left = Vector2(line_left, goal_post_top)
	goal_post_bottom_left = Vector2(line_left, goal_post_bottom)
	goal_post_top_right = Vector2(line_right, goal_post_top)
	goal_post_bottom_right = Vector2(line_right, goal_post_bottom)
	
	
	# penalty area
	var penalty_area_size:int = size.x / 7
	
	penalty_area_left_x = line_left + penalty_area_size
	penalty_area_right_x = line_right - penalty_area_size
	
	penalty_area_y_bottom = goal_post_bottom_left.y - penalty_area_size / 2
	penalty_area_y_top = goal_post_top_left.y + penalty_area_size / 2
	
	penalty_area_left = PackedVector2Array()
	penalty_area_right = PackedVector2Array()
	
	penalty_area_left.append(Vector2(line_left, penalty_area_y_bottom))
	penalty_area_left.append(Vector2(line_left + penalty_area_size, penalty_area_y_bottom))
	penalty_area_left.append(Vector2(line_left + penalty_area_size, penalty_area_y_top))
	penalty_area_left.append(Vector2(line_left, penalty_area_y_top))
	
	penalty_area_right.append(Vector2(line_right, penalty_area_y_bottom))
	penalty_area_right.append(Vector2(line_right - penalty_area_size, penalty_area_y_bottom))
	penalty_area_right.append(Vector2(line_right - penalty_area_size, penalty_area_y_top))
	penalty_area_right.append(Vector2(line_right, penalty_area_y_top))


func get_corner_pos(ball_exit_pos:Vector2) -> Vector2:
	# start from top/left
	var corner_pos:Vector2 = Vector2(0, 0)

	if ball_exit_pos.x > size.x / 2:
		corner_pos.x = line_right

	if ball_exit_pos.y > size.y / 2:
		corner_pos.y = line_bottom # bottom

	return corner_pos


func is_goal(ball_pos:Vector2) -> bool:
	return ball_pos.y > goal_post_bottom and ball_pos.y < goal_post_top


func get_goalkeeper_pos(plays_left:bool) -> Vector2:
	var pos:Vector2
	if plays_left:
		pos = goal_left
	else:
		pos = goal_right
	# move some pixels away from goal line
	pos.x = abs(pos.x - 5)
	return pos
