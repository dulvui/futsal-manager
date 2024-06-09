# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimGoalkeeper

signal short_pass
signal interception

# resources
var player_res: Player
var ball: SimBall
var field: SimField
var left_half: bool
# positions
var start_pos: Vector2
var pos: Vector2
# movements
var destination: Vector2
var speed: float

# base positions
var left_base: Vector2
var right_base: Vector2

var interception_radius: int  #TODO reduce radius with low stamina
# so goalkeeper cant block infinitly,
# but when once blocked, time has to pass to block again
var block_counter: int = 0


func set_up(
	p_player_res: Player,
	p_ball: SimBall,
	p_field: SimField,
	p_left_half: bool,
) -> void:
	player_res = p_player_res
	ball = p_ball
	field = p_field

	left_half = p_left_half

	start_pos = field.get_goalkeeper_pos(left_half)
	pos = start_pos
	destination = pos

	interception_radius = (player_res.attributes.goalkeeper.positioning / 2) + 10
	
	left_base = Vector2(field.line_left + 30, field.size.y / 2)
	right_base = Vector2(field.line_right - 30,  field.size.y / 2)


func update() -> void:
	match ball.state:
		SimBall.State.PASS, SimBall.State.STOP, SimBall.State.DRIBBLE:
			speed = 5
			if is_touching_ball():
				ball.stop()
				interception.emit()
				ball.state = SimBall.State.GOALKEEPER
		SimBall.State.SHOOT:
			speed = player_res.attributes.goalkeeper.reflexes
			if block_shot():
				ball.stop()
				interception.emit()
				ball.state = SimBall.State.GOALKEEPER

	if block_counter == 0:
		follow_ball()
	
	_move()


func follow_ball() -> void:
	# only follow if in own half
	if left_half:
		if ball.pos.x < field.size.x / 2:
			set_destination(ball.pos)
		else:
			set_destination(left_base)
			
	else:
		if ball.pos.x > field.size.x / 2:
			set_destination(ball.pos)
		else:
			set_destination(right_base)


func get_penalty_area_bounds(p_pos: Vector2) -> Vector2:
	if p_pos.y > field.penalty_area_y_top + 10:
		p_pos.y = field.penalty_area_y_top + 10
	elif p_pos.y < field.penalty_area_y_bottom - 10:
		p_pos.y = field.penalty_area_y_bottom - 10

	if left_half:
		if p_pos.x > field.penalty_area_left_x + 10:
			p_pos.x = field.penalty_area_left_x + 10
		elif p_pos.x < -10:
			p_pos.x = -10
	else:
		if p_pos.x < field.penalty_area_right_x - 10:
			p_pos.x = field.penalty_area_right_x - 10
		elif p_pos.x > field.size.x + field.BORDER_SIZE + 10:
			p_pos.x = field.size.x + field.BORDER_SIZE + 10
	
	return p_pos


func _move() -> void:
	if speed > 0:
		pos = pos.move_toward(destination, speed * Const.SPEED)



func set_destination(p_destination: Vector2) -> void:
	destination = get_penalty_area_bounds(p_destination)
	speed = 15


func stop() -> void:
	speed = 0


func is_touching_ball() -> bool:
	return ball.is_touching(pos, interception_radius)


func block_shot() -> bool:
	if block_counter > 0:
		block_counter -= 1
		return false
	if is_touching_ball():
		# stop blocking for x seconds
		block_counter = Const.TICKS_PER_SECOND * 2
		# best case 49 + 20 * 2 = 89
		# worst case 49 + 1 * 2 = 52
		return (
			Config.match_rng.randi_range(0, 100)
			< 49 + player_res.attributes.goalkeeper.handling * 2
		)
	return false


func set_pos(p_pos: Vector2 = pos) -> void:
	pos = p_pos
	# reset values
	speed = 0
	destination = Vector2.INF
