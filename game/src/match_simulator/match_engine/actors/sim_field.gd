# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimField

const PIXEL_FACTOR: int = 28

# in meters * PIXEL_FACTOR
const GOAL_SIZE: int = 3 * PIXEL_FACTOR
const BORDER_SIZE: int = 2 * PIXEL_FACTOR
const WIDTH: int = 42 * PIXEL_FACTOR
const HEIGHT: int = 25 * PIXEL_FACTOR
const PANALTY_AREA_RADIUS: int = 5 * PIXEL_FACTOR
const CENTER_CIRCLE_RADIUS: int = 3 * PIXEL_FACTOR
const LINE_WIDTH: float = 0.10 * PIXEL_FACTOR  # in cm

# Note: don't use Rect2, to keep simple and human-readable names for coordinates
var size: Vector2  # with borders
var center: Vector2
var top_left: Vector2
var top_right: Vector2
var bottom_left: Vector2
var bottom_right: Vector2
var line_top: int
var line_bottom: int
var line_left: int
var line_right: int

var goal_left: Vector2
var goal_right: Vector2

# y coordinates of goal posts
var goal_post_top: int
var goal_post_bottom: int

# x,y coordinates of all goal posts
var goal_post_top_left: Vector2
var goal_post_top_right: Vector2

var goal_post_bottom_left: Vector2
var goal_post_bottom_right: Vector2

var penalty_area_left_x: int
var penalty_area_right_x: int
var penalty_area_y_top: int
var penalty_area_y_bottom: int

var penalty_area_left: PackedVector2Array
var penalty_area_right: PackedVector2Array


func set_up() -> void:
	#size = sprite.texture.get_size()
	size = Vector2(WIDTH + BORDER_SIZE * 2, HEIGHT + BORDER_SIZE * 2)

	center = Vector2(size.x / 2, size.y / 2)

	line_top = BORDER_SIZE
	line_bottom = line_top + HEIGHT
	line_left = BORDER_SIZE
	line_right = line_left + WIDTH

	top_left = Vector2(line_left, line_top)
	top_right = Vector2(line_right, line_top)
	bottom_left = Vector2(line_left, line_bottom)
	bottom_right = Vector2(line_right, line_bottom)

	# goal
	goal_left = Vector2(line_left, size.y / 2)
	goal_right = Vector2(line_right, size.y / 2)

	goal_post_bottom = (size.y / 2) + (GOAL_SIZE / 2)
	goal_post_top = (size.y / 2) - (GOAL_SIZE / 2)

	goal_post_top_left = Vector2(line_left, goal_post_top)
	goal_post_bottom_left = Vector2(line_left, goal_post_bottom)
	goal_post_top_right = Vector2(line_right, goal_post_top)
	goal_post_bottom_right = Vector2(line_right, goal_post_bottom)

	# penalty area
	penalty_area_left = PackedVector2Array()
	penalty_area_right = PackedVector2Array()

	# create upper circle for penalty area
	var points: int = 12
	var curve: Curve2D = Curve2D.new()

	penalty_area_left_x = line_left + PANALTY_AREA_RADIUS
	penalty_area_right_x = line_right - PANALTY_AREA_RADIUS

	penalty_area_y_bottom = goal_post_bottom_left.y - PANALTY_AREA_RADIUS
	penalty_area_y_top = goal_post_top_left.y + PANALTY_AREA_RADIUS

	# left
	var start_point: Vector2 = Vector2(goal_post_top_left)
	var end_point: Vector2 = Vector2(goal_post_top_left + Vector2(PANALTY_AREA_RADIUS, 0))

	for i: int in points:
		curve.add_point(
			start_point + Vector2(0, -PANALTY_AREA_RADIUS).rotated((i / float(points)) * PI / 2)
		)
	curve.add_point(end_point)

	start_point = Vector2(goal_post_bottom_left)
	end_point = Vector2(goal_post_bottom_left + Vector2(0, PANALTY_AREA_RADIUS))

	for i: int in range(points, points + points):
		curve.add_point(
			start_point + Vector2(0, -PANALTY_AREA_RADIUS).rotated((i / float(points)) * PI / 2)
		)
	curve.add_point(end_point)

	penalty_area_left.append_array(curve.get_baked_points())

	# right
	curve.clear_points()
	curve.add_point(end_point)

	for i: int in range(points * 2, points * 3):
		curve.add_point(
			start_point + Vector2(0, -PANALTY_AREA_RADIUS).rotated((i / float(points)) * PI / 2)
		)
	curve.add_point(Vector2(goal_post_bottom_left - Vector2(PANALTY_AREA_RADIUS, 0)))

	start_point = Vector2(goal_post_top_left)
	end_point = Vector2(goal_post_top_left - Vector2(0, PANALTY_AREA_RADIUS))

	curve.add_point(Vector2(goal_post_top_left - Vector2(PANALTY_AREA_RADIUS, 0)))
	for i: int in range(points * 3, points * 4):
		curve.add_point(
			start_point + Vector2(0, -PANALTY_AREA_RADIUS).rotated((i / float(points)) * PI / 2)
		)
	curve.add_point(end_point)

	penalty_area_right.append_array(curve.get_baked_points())

	# move to opposite site
	for i in penalty_area_right.size():
		penalty_area_right[i] += Vector2(WIDTH, 0)


func get_corner_pos(ball_exit_pos: Vector2) -> Vector2:
	# start from top/left
	var corner_pos: Vector2 = Vector2(0, 0)

	if ball_exit_pos.x > size.x / 2:
		corner_pos.x = line_right

	if ball_exit_pos.y > size.y / 2:
		corner_pos.y = line_bottom  # bottom

	return corner_pos


func is_goal(ball_last_pos: Vector2, ball_pos: Vector2) -> Variant:
	var intersection: Variant

	# left
	if ball_pos.x < size.x / 2:
		intersection = Geometry2D.segment_intersects_segment(
			ball_last_pos, ball_pos, goal_post_bottom_left, goal_post_top_left
		)
	# right
	else:
		intersection = Geometry2D.segment_intersects_segment(
			ball_last_pos, ball_pos, goal_post_bottom_right, goal_post_top_right
		)

	if intersection and intersection.y < goal_post_bottom and intersection.y > goal_post_top:
		return intersection
	return null
