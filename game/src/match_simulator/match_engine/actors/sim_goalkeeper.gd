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
	p_start_pos:Vector2,
	p_ball:SimBall,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	pos = start_pos
	
	# worst case 10
	# best case  20
	interception_radius = (player_res.attributes.goalkeeper.positioning / 2) + 10

	left_half = pos.x < 600


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


func follow_ball() -> void:
	# only follow if in own half
	if (left_half and ball.pos.x < 600) or (not left_half and ball.pos.x > 600): 
		pos.y = goal_bounds_y(ball.pos.y)
	else:
		pos.y = 300

func move() -> void:
	if speed > 0:
		pos += direction * speed
	
	if pos.distance_to(destination) < 5 or speed == 0:
		destination = Vector2.INF
		stop()


func stop() -> void:
	speed = 0


func is_touching_ball() -> bool:
	return Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius)


func block_shot() -> bool:
	if is_touching_ball():
		# best case 59 + 20 * 2 = 99
		# worst case 59 + 1 * 2 = 62
		return Config.match_rng.randi_range(0, 100) < 59 + player_res.attributes.goalkeeper.handling * 2
	return false



func goal_bounds_y(p_y:float) -> float:
	p_y = maxi(mini(p_y, 350), 250)
	return p_y

func set_pos(p_pos:Vector2 = pos) -> void:
	pos = p_pos
	# reset values
	speed = 0
	destination = Vector2.INF
