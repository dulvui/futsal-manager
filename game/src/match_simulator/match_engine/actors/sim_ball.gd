# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimBall

signal goal_line_out
signal touch_line_out
signal goal

enum State { PASS, SHOOT, STOP, DRIBBLE, GOALKEEPER }

const DECELERATION: float = 1

var state: State

var pos: Vector2
# to save last position and be able to get segment between ticks, for interceptions
var last_pos: Vector2

var speed: float
var direction: Vector2

var players_in_shoot_trajectory: int
var empty_net: bool

var field: SimField

var clock_running: bool


func set_up(p_field: SimField) -> void:
	field = p_field
	pos = field.center
	last_pos = pos
	state = State.STOP
	clock_running = false


func set_pos(p_pos: Vector2) -> void:
	pos = p_pos
	stop()


func set_pos_xy(x: float, y: float) -> void:
	pos.x = x
	pos.y = y
	stop()


func update() -> void:
	if speed > 0:
		move()
		check_field_bounds()
	else:
		speed = 0


func move() -> void:
	last_pos = pos
	pos += direction * speed * Const.SPEED
	speed -= DECELERATION
	
	# when the ball moves, the clock is always running
	clock_running = true


func is_moving() -> bool:
	return speed > 0


func stop() -> void:
	speed = 0
	state = State.STOP
	last_pos = pos


func short_pass(p_destination: Vector2, force: float) -> void:
	speed = force + 0.2  # ball moves a bit faster that the force is
	direction = pos.direction_to(p_destination)
	state = State.PASS


func shoot(p_destination: Vector2, force: float) -> void:
	speed = force + 4  # ball moves a bit faster that the force is
	direction = pos.direction_to(p_destination)
	state = State.SHOOT


func dribble(p_destination: Vector2, force: float) -> void:
	speed = force
	direction = pos.direction_to(p_destination)
	state = State.DRIBBLE


func check_field_bounds() -> void:
	# kick in / y axis
	if pos.y < field.line_top:
		var intersection: Variant = Geometry2D.segment_intersects_segment(
			last_pos, pos, field.top_left, field.top_right
		)
		if intersection:
			set_pos(intersection)
			clock_running = false
			touch_line_out.emit()
			return
	if pos.y > field.line_bottom:
		var intersection: Variant = Geometry2D.segment_intersects_segment(
			last_pos, pos, field.bottom_left, field.bottom_right
		)
		if intersection:
			set_pos(intersection)
			clock_running = false
			touch_line_out.emit()
			return

	# goal or corner / x axis
	if pos.x < field.line_left or pos.x > field.line_right:
		# TODO check if post was hit => reflect
		var goal_intersection: Variant = field.is_goal(last_pos, pos)
		if goal_intersection:
			set_pos(goal_intersection as Vector2)
			clock_running = false
			goal.emit()
			return
		# corner
		clock_running = false
		goal_line_out.emit()
		return


func is_touching(p_pos: Vector2, p_radius: int, log_debug: bool = false) -> bool:
	#if pos.distance_to(last_pos) < 5:
	var test: bool = Geometry2D.is_point_in_circle(pos, p_pos, p_radius)
	if log_debug:
		print(pos)
		print(p_pos)
		print(p_radius)
		print(test)

	return test
	#return Geometry2D.segment_intersects_circle(last_pos, pos, p_pos, p_radius) != -1
	#return Geometry2D.segment_intersects_segment(last_pos, pos, p_last_pos, p_pos) != null
