extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT}

var destination = Vector2(0,200)


var state

var dinstance_to_ball
var target

var velocity = 1

func _ready():
	$ColorRect.color = color


func set_up(nr, start_position):
	position = start_position
	$ShirtNumber.text = str(nr)
	
func move(final_position, time):
	$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
