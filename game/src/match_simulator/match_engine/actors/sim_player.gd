# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimPlayer

signal interception
signal short_pass
signal shoot
signal dribble
signal pass_received

enum State {
	# attack with ball
	BALL,
	# attack without ball
	NO_BALL,
	RECEIVE,
}

const DECELERATION: float = 0.01

var state:State

# resources
var player_res: Player
var ball:SimBall
var field:SimField
var left_half: bool
# positions
var start_pos:Vector2
var pos:Vector2
# movements
var direction:Vector2
var destination:Vector2
var speed: int
# fisical attributes
var stamina:float
var interception_radius: int #TODO reduce radius with low stamina

# distances, calculated by actiopn util
var distance_to_goal:float
var distance_to_own_goal:float
var distance_to_ball:float
var distance_to_enemy:float


func set_up(
	p_player_res: Player,
	p_ball:SimBall,
) -> void:
	player_res = p_player_res
	ball = p_ball
	
	# inital test values
	destination = Vector2.INF
	interception_radius = 10
	speed = 15


func defend() -> void:
	if is_touching_ball():
		interception.emit()
		state = State.BALL
		ball.stop()
	else:
		state = State.NO_BALL


func attack() -> void:
	match state:
		State.RECEIVE:
			if is_touching_ball():
				pass_received.emit()
				state = State.BALL
				ball.stop()
		State.BALL:
			if _should_pass():
				short_pass.emit()
				state = State.NO_BALL
			elif _should_shoot():
				shoot.emit()
				state = State.NO_BALL


func kick_off(p_pos:Vector2) -> void:
	start_pos = p_pos
	set_pos()


func move() -> void:
	if state != State.RECEIVE and speed > 0:
		pos += direction * speed
		speed -= DECELERATION
		stamina -= 0.01
	
	if pos.distance_to(destination) < 20 or speed == 0:
		destination = Vector2.INF
		stop()


func is_touching_ball() -> bool:
	return ball.is_touching(pos, interception_radius)


func is_intercepting_ball() -> bool:
	return Config.match_rng.randi_range(1, 100) < 59 + player_res.attributes.technical.interception * 2


func set_pos(p_pos:Vector2 = pos) -> void:
	pos = p_pos
	# reset values
	speed = 0
	destination = Vector2.INF


func set_destination(p_destination:Vector2) -> void:
	p_destination = bound_field(p_destination)
	
	if pos.distance_to(p_destination) > 20:
		destination = p_destination
		direction = pos.direction_to(destination)
		# TODO use speed of attributes
		speed = Config.match_rng.randi_range(10, 20)


func stop() -> void:
	speed = 0


func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if  ball.players_in_shoot_trajectory < 2:
		return Config.match_rng.randi_range(1, 100) > 95
	return false
	
	
func _should_pass() -> bool:
	if distance_to_enemy < 50:
		return Config.match_rng.randi_range(1, 100) < 60
	return false


func _next_random_direction() -> void:
	if destination == Vector2.INF:
		# random destination
		set_destination(
			bound_field(
				pos + Vector2(Config.match_rng.randi_range(-150, 150),
				Config.match_rng.randi_range(-150, 150)
				)
			)
		)


func bound_field(p_pos:Vector2) -> Vector2:
	p_pos.x = maxi(mini(p_pos.x, 1200), 1)
	p_pos.y = maxi(mini(p_pos.y, 600), 1)
	return p_pos
	
