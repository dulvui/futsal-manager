# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SimPlayer

signal interception
signal short_pass
signal shoot
signal dribble
signal pass_received

enum State {
	# generic
	START_POS,
	WAIT,
	# defense
	PRESS,
	# attack
	BALL,
	RECEIVE,
	PASS,
	FORCE_PASS,
	SHOOT,
}

const deceleration = 0.01

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
var speed:int
# fisical attributes
var stamina:float
var interception_radius:int #TODO reduce radius with low stamina

# distances, calculated by actiopn util
var distance_to_goal:float
var distance_to_own_goal:float
var distance_to_active_player:float
var distance_to_ball:float
var distance_to_enemy:float

func set_up(
	p_player_res:Player,
	p_start_pos:Vector2,
	p_ball:SimBall,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	pos = start_pos
	
	# inital test values
	destination = Vector2.INF
	interception_radius = 25
	speed = 15
	state = State.START_POS


func update() -> void:
	if state == State.RECEIVE or state == State.PRESS:
		if intercepts():
			if state == State.RECEIVE:
				pass_received.emit()
			
			state = State.BALL
			ball.stop()
			interception.emit()

			
	elif state == State.FORCE_PASS:
		state = State.PASS
		short_pass.emit()
	
	elif state == State.BALL: # if player has ball not just received
		if _should_pass():
			state = State.PASS
			short_pass.emit()
		elif _should_shoot():
			state = State.SHOOT
			shoot.emit()
	
	if state != State.RECEIVE:
		# TODO use pos from tactics
		_next_direction()


func act() -> void:
	# move
	if speed > 0:
		pos += direction * speed
		speed -= deceleration
		stamina -= 0.01
	
	if pos.distance_to(destination) < 20 or speed == 0:
		destination = Vector2.INF
		stop()


func intercepts() -> bool:
	if Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		# TODO use player block attributes
		#return true
		return Config.match_rng.randi_range(0, 100) < 95
	return false


func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	# reset values
	speed = 0
	destination = Vector2.INF


func set_destination(p_destination:Vector2) -> void:
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


func _next_direction() -> void:
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
	
