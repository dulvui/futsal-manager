extends Area2D

export var color = Color.rebeccapurple
export var nr:int = 1

func _ready():
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)

func move_to(destination,wait_time):
	$Tween.interpolate_property(self,"position",position,destination,wait_time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
