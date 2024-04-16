# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

const random_factor = 90

@export var color:Color = Color.REBECCA_PURPLE
@export var is_field_player:bool = true
@onready var sprite:Node2D = $Sprites

var moved:bool = false

var field_width:int
var field_height:int

var player:Player

var is_home_player:bool


func set_up(_player:Player, _color:Color, _is_home_player:bool, _field_width:int, _field_height:int, start_position:Vector2 = Vector2.ZERO) -> void:
	player = _player
	if start_position != Vector2.ZERO:
		position = start_position
	$ShirtNumber.text = str(player.surname)
	$Sprites/Body.self_modulate = _color
	field_height = _field_height
	field_width = _field_width
	is_home_player = _is_home_player
	
func move(destination:Vector2, time:float) -> Vector2:
	var tween:Tween = create_tween()
	destination = _stay_inside_field(destination)
	tween.tween_property(self, "position", destination, time)
#	tween.start()
	moved = true
	return destination
	
func random_movement(time:float, is_home_attack:bool) -> void:
	var rand_x:float = randf_range(-random_factor,random_factor)
	var rand_y:float = randf_range(-random_factor,random_factor)
	
	# move towards goal, or away on possession change
	if is_home_attack:
		rand_x -= abs(random_factor)
	else:
		rand_x += abs(random_factor)

	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position:Vector2 = _stay_inside_field(position - Vector2(rand_x,rand_y))
			var tween:Tween = create_tween()
			tween.tween_property(self, "position", final_position, time)

func celebrate_goal() -> void:
	random_movement(randf_range(0.5, 1.5), true)

func _stay_inside_field(destination: Vector2) -> Vector2:
			# player should not go outside the field
		if destination.x < 0:
			destination.x = randf_range(20, 45)
		if destination.y < 0:
			destination.y = randf_range(20, 45)
		if destination.x > field_width:
			destination.x = randf_range(field_width - 45, field_width - 25)
		if destination.y > field_height:
			destination.y = randf_range(field_height - 45, field_height - 25)
		return destination
