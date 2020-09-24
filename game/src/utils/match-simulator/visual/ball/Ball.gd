extends Area2D


func move_to(destination):
	$Tween.interpolate_property(self,"position",position,destination,1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func kick_off():
	position = Vector2(600,300)
