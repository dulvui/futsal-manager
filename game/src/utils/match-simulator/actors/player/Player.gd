extends KinematicBody2D

export var color = Color.rebeccapurple
export var nr:int = 1



func _ready():
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)

func set_up(teamcolor,number):
	color = teamcolor
	nr = number
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)
