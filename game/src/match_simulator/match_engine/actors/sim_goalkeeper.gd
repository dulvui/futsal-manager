# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimGoalkeeper

signal short_pass
signal interception

# resources
var player_res:Player
var ball:SimBall
var field:SimField
var left_half:bool
# positions
var start_pos:Vector2
var pos:Vector2
# movements
var direction:Vector2
var destination:Vector2
var speed:float

var interception_radius:int #TODO reduce radius with low stamina

func set_up(
	p_player_res:Player,
	p_ball:SimBall,
	p_field:SimField,
	p_left_half:bool,
) -> void:
	player_res = p_player_res
	ball = p_ball
	field = p_field
	
	left_half = p_left_half
	
	start_pos = field.get_goalkeeper_pos(left_half)
	pos = start_pos
	
	# worst case 10
	# best case  20
	interception_radius = (player_res.attributes.goalkeeper.positioning / 2) + 10



func defend() -> void:
	match ball.state:
		SimBall.State.PASS, SimBall.State.STOP, SimBall.State.DRIBBLE:
			speed = 5
			if is_touching_ball():
				ball.stop()
				interception.emit()
		SimBall.State.SHOOT:
			speed = player_res.attributes.goalkeeper.reflexes
			if block_shot():
				ball.stop()
				interception.emit()

	follow_ball()



func attack() -> void:
	if is_touching_ball():
		ball.stop()
		short_pass.emit()
		
	follow_ball()


func follow_ball() -> void:
	# only follow if in own half
	if left_half:
		if ball.pos.x < 600:
			pos = ball.pos
			set_penalty_area_bounds()
		else:
			pos.y = 300
			pos.x = 30
	else:
		if ball.pos.x > 600:
			pos = ball.pos
			set_penalty_area_bounds()
		else:
			pos.y = 300
			pos.x = 1170


func set_penalty_area_bounds() -> void:
	if pos.y > field.penalty_area_y_upper + 10:
		pos.y = field.penalty_area_y_upper + 10
	elif pos.y < field.penalty_area_y_lower - 10:
		pos.y = field.penalty_area_y_lower - 10
	
	if left_half:
		if pos.x > field.penalty_area_left_x + 10:
			pos.x = field.penalty_area_left_x + 10
		elif pos.x < -10:
			pos.x = -10
	else:
		if pos.x < field.penalty_area_right_x - 10:
				pos.x = field.penalty_area_right_x - 10
		elif pos.x > field.size.x + 10:
			pos.x = field.size.x + 10

func move() -> void:
	if speed > 0:
		pos += direction * speed
	
	if pos.distance_to(destination) < 5 or speed == 0:
		destination = Vector2.INF
		stop()


func stop() -> void:
	speed = 0


func is_touching_ball() -> bool:
	return ball.is_touching(pos, interception_radius)


func block_shot() -> bool:
	if is_touching_ball():
		# best case 59 + 20 * 2 = 99
		# worst case 59 + 1 * 2 = 62
		return Config.match_rng.randi_range(0, 100) < 59 + player_res.attributes.goalkeeper.handling * 2
	return false


func set_pos(p_pos:Vector2 = pos) -> void:
	pos = p_pos
	# reset values
	speed = 0
	destination = Vector2.INF
