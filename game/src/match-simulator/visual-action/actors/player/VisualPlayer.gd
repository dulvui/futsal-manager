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
	
func random_movement(time):
	if is_field_player:
		if moved:
			moved = false
		else:
			var final_position = position - Vector2(rand_range(-50,50),rand_range(-50,50))
			$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
