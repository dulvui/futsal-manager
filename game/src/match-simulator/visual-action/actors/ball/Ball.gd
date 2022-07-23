extends Node2D

func move(final_position, time, is_global_position = false):
	if is_global_position:
		$Tween.interpolate_property(self, "global_position", global_position, final_position, time, Tween.EASE_IN, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property(self, "position", position, final_position, time, Tween.EASE_IN, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "rotation", rand_range(-5,5), rand_range(-5,5), time, Tween.EASE_IN, Tween.EASE_OUT)
	$Tween.start()
