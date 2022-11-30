extends Node2D


const moveTrans = Tween.TRANS_LINEAR
const moveEase = Tween.EASE_OUT

func follow_ball(ball_position, time) -> void:
	ball_position.y = position.y
	$Tween.interpolate_property(self, "position", position, ball_position, time, moveTrans, moveEase)
	$Tween.start()
