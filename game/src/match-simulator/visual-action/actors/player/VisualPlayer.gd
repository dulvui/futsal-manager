extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

var moved = false

onready var sprite = $Sprites
export var is_field_player = true

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
	destination = _stay_inside_field(destination)
	$Tween.interpolate_property(self, "position", position, destination, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	moved = true
	return destination
	
func random_movement(time) -> void:
	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position = _stay_inside_field(position - Vector2(rand_range(-50,50),rand_range(-50,50)))
			$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()

func _stay_inside_field(destination: Vector2) -> Vector2:
			# player should not go outside the field
		if destination.x < 0:
			destination.x = rand_range(20, 45)
		if destination.y < 0:
			destination.y = rand_range(20, 45)
		if destination.x > field_width:
			destination.x = rand_range(field_width - 45, field_width - 25)
		if destination.y > field_height:
			destination.y = rand_range(field_height - 45, field_height - 25)
		return destination
