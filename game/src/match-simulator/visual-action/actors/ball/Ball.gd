extends Node2D

const moveTrans = Tween.TRANS_LINEAR
const moveEase = Tween.EASE_OUT

func move(final_position, time, is_global_position = false):
	if is_global_position:
		$Tween.interpolate_property(self, "global_position", global_position, final_position, time, moveTrans, moveEase)
	else:
		$Tween.interpolate_property(self, "position", position, final_position, time, moveTrans, moveEase)
	$Tween.interpolate_property(self, "rotation", rand_range(-5,5), rand_range(-5,5), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
