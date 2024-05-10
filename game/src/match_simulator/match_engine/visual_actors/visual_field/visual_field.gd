# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name VisualField

@onready var lines:Node2D = $Lines

var field:SimField

func _draw() -> void:
	# TODO use draw_rect
	# hack for field color
	draw_circle(field.center, field.width + field.height, Color.ORANGE)
	# center circle
	draw_circle(field.center, field.center_circle_radius + field.line_width, Color.WHITE)
	draw_circle(field.center, field.center_circle_radius, Color.ORANGE)
	
	# outer lines
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_right,  field.line_top), Color.WHITE, field.line_width)
	draw_line(Vector2(field.line_right,  field.line_top), Vector2(field.line_right,  field.line_bottom), Color.WHITE, field.line_width)
	draw_line(Vector2(field.line_right,  field.line_bottom), Vector2(field.line_left,  field.line_bottom), Color.WHITE, field.line_width)
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_left,  field.line_bottom), Color.WHITE, field.line_width)
	
	# goals
	draw_dashed_line(field.goal_post_top_left, field.goal_post_bottom_left, Color.FIREBRICK, field.line_width, field.line_width)
	draw_dashed_line(field.goal_post_top_right, field.goal_post_bottom_right, Color.FIREBRICK, field.line_width, field.line_width)
	


func set_up(p_field:SimField) -> void:
	field = p_field
	
	# penalty area lines
	var penalty_area_line_left:Line2D = Line2D.new()
	penalty_area_line_left.width = field.line_width
	for point:Vector2 in field.penalty_area_left:
		penalty_area_line_left.add_point(point)
	lines.add_child(penalty_area_line_left)
	
	var penalty_area_line_right:Line2D = Line2D.new()
	penalty_area_line_right.width = field.line_width
	for point:Vector2 in field.penalty_area_right:
		penalty_area_line_right.add_point(point)
	lines.add_child(penalty_area_line_right)

	
	# middle line
	var middle_line:Line2D = Line2D.new()
	middle_line.width = field.line_width
	middle_line.add_point(Vector2(field.center.x, field.line_top))
	middle_line.add_point(Vector2(field.center.x,  field.line_bottom))
	lines.add_child(middle_line)
	
