# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimGoalkeeper

signal short_pass

enum State {
	FOLLOW_BALL,
	# defense
	SAVE_SHOT,
	# attack with ball
	PASS,
}

var state:State
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
	
	state = State.FOLLOW_BALL
	# worst case 11
	# best case  30
	interception_radius = player_res.attributes.goalkeeper.positioning + 10


func update() -> void:
	match state:
		State.FOLLOW_BALL:
			speed = 5
			if (left_half and ball.pos.x < 600) or (not left_half and ball.pos.x > 600): 
				pos.y = goal_bounds_y(ball.pos.y)
			else:
				pos.y = 300
		State.SAVE_SHOT:
			speed = player_res.attributes.goalkeeper.reflexes
			pos.y = goal_bounds_y(ball.pos.y)
			if is_touching_ball():
				state = State.PASS
				ball.stop()
		State.PASS:
			short_pass.emit()
			state = State.FOLLOW_BALL
	
func move() -> void:
	if speed > 0:
		pos += direction * speed
	
	if pos.distance_to(destination) < 5 or speed == 0:
		destination = Vector2.INF
		stop()

func save_shot() -> void:
	print("save shot")
	state = State.SAVE_SHOT
	
func kick_in() -> void:
	state = State.PASS

func stop() -> void:
	speed = 0
	
func is_touching_ball() -> bool:
	if Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		# best case 59 + 20 * 2 = 99
		# worst case 59 + 1 * 2 = 62
		return Config.match_rng.randi_range(0, 100) < 59 + player_res.attributes.goalkeeper.handling * 2
	return false

func goal_bounds_y(p_y:float) -> float:
	p_y = maxi(mini(p_y, 350), 250)
	return p_y
