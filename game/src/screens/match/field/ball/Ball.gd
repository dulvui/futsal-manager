extends Node2D

var height = 0 # saves height so if cross, bal goes trough players

func move_to(destination):
	$Tween.interpolate_property(self,"global_position",global_position,destination,0.2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
