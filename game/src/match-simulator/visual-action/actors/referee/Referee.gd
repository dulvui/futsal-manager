extends Node2D


func follow_ball(ball_position, time) -> void:
	var tween:Tween = create_tween()
	ball_position.y = position.y
	tween.tween_property(self, "position", ball_position, time)
#	tween.start()
