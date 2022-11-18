extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

var moved = false

onready var sprite = $Sprites
export var is_field_player = true


func set_up(_nr, color, is_home_player, start_position = null):
	if start_position:
		position = start_position
	nr = _nr
	$ShirtNumber.text = str(nr)
	$Sprites/Body.self_modulate = color
	
func move(final_position, time):
	if is_field_player:
		$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		moved = true
	
func random_movement(time, field_width, field_height):
	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position = position - Vector2(rand_range(-50,50),rand_range(-50,50))
			
			# player should not go outside the field
			if final_position.x < 0:
				final_position.x = rand_range(0, 25)
			if final_position.y < 0:
				final_position.y = rand_range(0, 25)
			if final_position.x > field_width:
				final_position.x = rand_range(field_width - 25, field_width)
			if final_position.y > field_height:
				final_position.y = rand_range(field_height - 25, field_height)
			
			
			$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
