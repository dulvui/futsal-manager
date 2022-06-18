extends Node2D

export var color = Color.rebeccapurple
export var nr:int = 1

enum states {CHASE,KICK,WAIT,HOME,SUPPORT}

var destination = Vector2(0,200)

var profile

var state

var dinstance_to_ball
var target

var velocity = 1

func _ready():
	$ColorRect.color = color


func set_up(_profile):
	profile = _profile
	if profile:
		$ShirtNumber.text = str(profile["nr"])
