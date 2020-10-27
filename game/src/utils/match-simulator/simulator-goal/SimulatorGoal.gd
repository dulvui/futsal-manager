extends Node

var left_post
var right_post
var center
var facing

func set_up(home, field_size):
	if home:
		center = Vector2(0, field_size.y / 2)
		left_post = center + Vector2(0, 50)
		right_post = center + Vector2(0, -50)
		facing = Vector2(1,0)
	else:
		center = Vector2(field_size.x, field_size.y / 2)
		left_post = center + Vector2(0, -50)
		right_post = center + Vector2(0, 50)
		facing = Vector2(-1,0)
