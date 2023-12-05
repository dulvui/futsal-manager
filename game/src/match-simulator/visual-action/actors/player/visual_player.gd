# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

@export
var color:Color = Color.REBECCA_PURPLE

var moved:bool = false

@onready var sprite:Node2D = $Sprites
@export var is_field_player:bool = true

var field_width:int
var field_height:int

var player:Player


func set_up(_player:Player, _color:Color, is_home_player:bool, _field_width:int, _field_height:int, start_position:Vector2 = Vector2.ZERO) -> void:
	player = _player
	if start_position != Vector2.ZERO:
		position = start_position
	$ShirtNumber.text = str(player.surname)
	$Sprites/Body.self_modulate = _color
	field_height = _field_height
	field_width = _field_width
	
func move(destination:Vector2, time:float) -> Vector2:
	var tween:Tween = create_tween()
	destination = _stay_inside_field(destination)
	tween.tween_property(self, "position", destination, time)
#	tween.start()
	moved = true
	return destination
	
func random_movement(time:float) -> void:
	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position:Vector2 = _stay_inside_field(position - Vector2(randf_range(-50,50),randf_range(-50,50)))
			var tween:Tween = create_tween()
			tween.tween_property(self, "position", final_position, time)

func celebrate_goal() -> void:
	random_movement(randf_range(0.5, 1.5))

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
