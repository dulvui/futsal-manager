# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name VisualField

@onready var lines:Node2D = $Lines
#@onready var goals:Node2D = $Goals

var field:SimField

func _draw() -> void:
	# TODO use draw_rect
	# hack for field color
	draw_circle(field.center, field.width + field.height, Color.ORANGE)
	# center circle
	draw_circle(field.center, 140, Color.WHITE)
	draw_circle(field.center, 130, Color.ORANGE)
	
	# outer lines
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_right,  field.line_top), Color.WHITE, 10)
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_left,  field.line_bottom), Color.WHITE, 10)
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_right,  field.line_top), Color.WHITE, 10)
	draw_line(Vector2(field.line_left, field.line_top), Vector2(field.line_right,  field.line_top), Color.WHITE, 10)
	
	draw_dashed_line(field.goal_post_top_left, field.goal_post_bottom_left, Color.FIREBRICK, 10, 10)
	draw_dashed_line(field.goal_post_top_right, field.goal_post_bottom_right, Color.FIREBRICK, 10, 10)
	


func set_up(p_field:SimField) -> void:
	field = p_field
	
	# penalty area lines
	var penalty_area_line_left:Line2D = Line2D.new()
	var penalty_area_line_right:Line2D = Line2D.new()
	
	for point:Vector2 in field.penalty_area_left:
		penalty_area_line_left.add_point(point)
	
	for point:Vector2 in field.penalty_area_right:
		penalty_area_line_right.add_point(point)
	
	lines.add_child(penalty_area_line_right)
	lines.add_child(penalty_area_line_left)
	
	# outer lines
	#var outer_line:Line2D = Line2D.new()
	#outer_line.add_point(Vector2(field.line_left, field.line_top))
	#outer_line.add_point(Vector2(field.line_right,  field.line_top))
	#outer_line.add_point(Vector2(field.line_right,  field.line_bottom))
	#outer_line.add_point(Vector2(field.line_left,  field.line_bottom))
	#outer_line.closed = true
	#lines.add_child(outer_line)
	
	# middle line
	var middle_line:Line2D = Line2D.new()
	middle_line.add_point(Vector2(field.center.x, field.line_top))
	middle_line.add_point(Vector2(field.center.x,  field.line_bottom))
	lines.add_child(middle_line)
	
