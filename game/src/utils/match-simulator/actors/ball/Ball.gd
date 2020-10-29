extends RigidBody2D
#
#
#func move_to(destination,wait_time):
#	$Tween.interpolate_property(self,"position",position,destination,wait_time,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.start()
	
func kick_off():
	position = Vector2(600,300)
