# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D
class_name SimPlayer

signal interception
signal short_pass
signal shoot
signal dribble

enum State {POSSESS, FREE, PASS, RECEIVE}

@onready var body:Sprite2D = $Sprites/Body

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
var speed:float
# fisical attributes
var stamina:float
var interception_radius:int #TODO reduce radius with low stamina

# ticks player has ball, 0 means no ball
var has_ball:int

# distances, calculated by actiopn util
var distance_to_goal:float
var distance_to_own_goal:float
var distance_to_active_player:float
var distance_to_ball:float
var distance_to_enemy:float


func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(pos, delta * speed)
	look_at(ball.global_position)

func set_up(
	p_player_res:Player,
	p_start_pos:Vector2,
	p_ball:SimBall,
	p_is_simulation:bool = false,
) -> void:
	player_res = p_player_res
	start_pos = p_start_pos
	ball = p_ball
	pos = start_pos
	
	# inital test values
	destination = Vector2.INF
	interception_radius = 25
	speed = 15
	has_ball = 0
	state = State.FREE

	global_position = pos
	# disables _physics_process, if simulation
	set_physics_process(not p_is_simulation)

func update() -> void:
	if has_ball == 0 and intercepts():
		state = State.POSSESS
		has_ball = 1
		ball.stop()
		interception.emit()
	
	if has_ball >= 1: # if player has ball not just received
		if _should_pass():
			has_ball = 0
			state = State.FREE
			short_pass.emit()
		elif _should_shoot():
			has_ball = 0
			shoot.emit()
	
	if state == State.FREE:
		# TODO use pos from tactics
		_next_direction()
	
	# count seconds player has ball
	if has_ball > 0:
		has_ball += 1

func act() -> void:
	# move
	if speed > 0:
		pos += direction * speed
		speed -= deceleration
		stamina -= 0.01
	
	if pos.distance_to(destination) < 1 or speed == 0:
		destination = Vector2.INF
		stop()
	
func intercepts() -> bool:
	if Geometry2D.is_point_in_circle(ball.pos, pos, interception_radius):
		# TODO use player block attributes
		#return true
		return Config.match_rng.randi_range(0, 100) < 60
	return false

func set_pos(p_pos:Vector2) -> void:
	pos = p_pos
	global_position = pos
	# reset values
	speed = 0
	has_ball = 0
	destination = Vector2.INF
	
func set_destination(p_destination:Vector2) -> void:
	destination = p_destination
	direction = pos.direction_to(destination)
	# TODO use speed of attributes
	speed = 2

func stop() -> void:
	speed = 0

func set_color(p_color:Color) -> void:
	body.modulate = p_color
	
func set_free() -> void:
	state = State.FREE

	

func _should_shoot() -> bool:
	if ball.empty_net:
		return true
	if  ball.players_in_shoot_trajectory <= 2:
		return Config.match_rng.randi_range(1, 100) < 2
	return false
	
	
func _should_pass() -> bool:
	if state != State.FREE:
		return true
	if distance_to_enemy < 50:
		return Config.match_rng.randi_range(1, 100) < 60
	return false

func _next_direction() -> void:
	if destination == Vector2.INF:
		set_destination(Vector2(randi_range(1, 1200), randi_range(1, 600)))

