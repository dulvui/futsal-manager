extends Area2D


func move_to(destination):
	$Tween.interpolate_property(self,"position",position,destination,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
