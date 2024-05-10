# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimField

const pixel_factor:int = 28

# in meters * pixel_factor
const goal_size:int = 3 * pixel_factor
const border_size:int = 2 * pixel_factor
const width:int = 42 * pixel_factor
const height:int = 25 * pixel_factor
const panalty_area_radius:int = 5 * pixel_factor
const center_circle_radius:int = 3 * pixel_factor
const line_width:float = 0.30 * pixel_factor # in cm

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
	
	goal_post_bottom = (size.y / 2) + (goal_size / 2)
	goal_post_top = (size.y / 2) - (goal_size / 2)
	
	goal_post_top_left = Vector2(line_left, goal_post_top)
	goal_post_bottom_left = Vector2(line_left, goal_post_bottom)
	goal_post_top_right = Vector2(line_right, goal_post_top)
	goal_post_bottom_right = Vector2(line_right, goal_post_bottom)
	
	
	# penalty area
	penalty_area_left = PackedVector2Array()
	penalty_area_right = PackedVector2Array()
	
	# create upper circle for penalty area
	var points:int = 12
	var curve:Curve2D = Curve2D.new()
	
	penalty_area_left_x = line_left + panalty_area_radius
	penalty_area_right_x = line_right - panalty_area_radius
	
	penalty_area_y_bottom = goal_post_bottom_left.y - panalty_area_radius
	penalty_area_y_top = goal_post_top_left.y + panalty_area_radius
	
	# left
	var start_point:Vector2 = Vector2(goal_post_top_left)
	var end_point:Vector2 = Vector2(goal_post_top_left + Vector2(panalty_area_radius, 0))
	
	for i:int in points:
		curve.add_point(start_point + Vector2(0, -panalty_area_radius).rotated((i / float(points)) * PI / 2))
	curve.add_point(end_point)
	
	start_point = Vector2(goal_post_bottom_left)
	end_point = Vector2(goal_post_bottom_left + Vector2(0, panalty_area_radius))
	
	for i:int in range(points, points + points):
		curve.add_point(start_point + Vector2(0, -panalty_area_radius).rotated((i / float(points)) * PI / 2))
	curve.add_point(end_point)
	
	penalty_area_left.append_array(curve.get_baked_points())
	
	# right
	curve.clear_points()
	curve.add_point(end_point)
	
	for i:int in range(points * 2,  points * 3):
		curve.add_point(start_point + Vector2(0, -panalty_area_radius).rotated((i / float(points)) * PI / 2))
	curve.add_point(Vector2(goal_post_bottom_left - Vector2(panalty_area_radius, 0)))
	
	start_point = Vector2(goal_post_top_left)
	end_point = Vector2(goal_post_top_left - Vector2(0, panalty_area_radius))
	
	curve.add_point(Vector2(goal_post_top_left - Vector2(panalty_area_radius, 0)))
	for i:int in range(points * 3,  points * 4):
		curve.add_point(start_point + Vector2(0, -panalty_area_radius).rotated((i / float(points)) * PI / 2))
	curve.add_point(end_point)
	
	penalty_area_right.append_array(curve.get_baked_points())
	
	# move to opposite site
	for i in penalty_area_right.size():
		penalty_area_right[i] += Vector2(width, 0)


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
