extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT}

var destination = Vector2(0,200)


var state

var dinstance_to_ball
var target

var velocity = 1

var moved = false

onready var sprite = $Sprite

export var is_field_player = true


func set_up(nr, start_position, color, home_player):
	position = start_position
	$ShirtNumber.text = str(nr)
	$ColorRect.color = color
	$Sprite.self_modulate = color
#	if home_player and is_field_player:
#		rotation_degrees -= 180
	
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
