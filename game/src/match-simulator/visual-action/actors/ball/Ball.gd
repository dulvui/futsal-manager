extends RigidBody2D

func _ready():
	pass
	
func move(destination):
	apply_central_impulse(destination - global_position)
