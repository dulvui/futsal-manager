# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-late

extends Node2D
class_name VisualField

var field:SimField

func set_up(p_field:SimField) -> void:
	field = p_field
	
	# create and draw penalty area lines
	var penalty_area_line_left:Line2D = Line2D.new()
	var penalty_area_line_right:Line2D = Line2D.new()
	
	for point:Vector2 in field.penalty_area_left:
		penalty_area_line_left.add_point(point)
	penalty_area_line_left.add_point(field.penalty_area_left[0])
	
	for point:Vector2 in field.penalty_area_right:
		penalty_area_line_right.add_point(point)
	penalty_area_line_right.add_point(field.penalty_area_right[0])
	
	add_child(penalty_area_line_right)
	add_child(penalty_area_line_left)
	
	# outer lines
	var outer_line:Line2D = Line2D.new()
	outer_line.add_point(Vector2(field.line_left, field.line_top))
	outer_line.add_point(Vector2(field.line_right,  field.line_top))
	outer_line.add_point(Vector2(field.line_right,  field.line_bottom))
	outer_line.add_point(Vector2(field.line_left,  field.line_bottom))
	outer_line.add_point(Vector2(field.line_left, field.line_top))
	add_child(outer_line)
	
	# middle line
	var middle_line:Line2D = Line2D.new()
	middle_line.add_point(Vector2(field.center.x, field.line_top))
	middle_line.add_point(Vector2(field.center.x,  field.line_bottom))
	add_child(middle_line)
	
	# center circle
	
