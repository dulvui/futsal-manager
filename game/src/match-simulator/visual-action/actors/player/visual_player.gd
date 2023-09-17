# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D

@export
var color = Color.REBECCA_PURPLE
@export 
var nr:int = 1

var moved = false

@onready var sprite = $Sprites
@export 
var is_field_player = true

var field_width
var field_height



func set_up(_nr, _color, is_home_player, _field_width, _field_height, start_position = null) -> void:
	if start_position:
		position = start_position
	nr = _nr
	$ShirtNumber.text = str(nr)
	$Sprites/Body.self_modulate = _color
	field_height = _field_height
	field_width = _field_width
	
func move(destination, time) -> Vector2:
	var tween:Tween = create_tween()
	destination = _stay_inside_field(destination)
	tween.tween_property(self, "position", destination, time)
#	tween.start()
	moved = true
	return destination
	
func random_movement(time) -> void:
	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position = _stay_inside_field(position - Vector2(randf_range(-50,50),randf_range(-50,50)))
			var tween:Tween = create_tween()
			tween.tween_property(self, "position", final_position, time)
#			tween.start()

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
