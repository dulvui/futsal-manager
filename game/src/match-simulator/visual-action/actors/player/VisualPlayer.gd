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

func _ready():
	pass


func set_up(nr, start_position, color):
	position = start_position
	$ShirtNumber.text = str(nr)
	$ColorRect.color = color
	
func move(final_position, time):
	$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	moved = true
	
func wait(time):
	if moved:
		moved = false
	else:
		var final_position = position - Vector2(rand_range(-50,50),rand_range(-50,50))
		$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.start()
