extends Area2D

export var color = Color.rebeccapurple
export var nr:int = 1

func _ready():
	$Control/ColorRect.color = color
	$Control/ShirtNumber.text = str(nr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
