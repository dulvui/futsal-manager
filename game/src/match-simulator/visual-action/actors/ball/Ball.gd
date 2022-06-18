extends Node2D

func move(final_position, time):
	$Tween.interpolate_property(self, "position", position, final_position, time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
