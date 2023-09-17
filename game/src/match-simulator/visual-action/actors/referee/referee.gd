# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D


func follow_ball(ball_position, time) -> void:
	var tween:Tween = create_tween()
	ball_position.y = position.y
	tween.tween_property(self, "position", ball_position, time)
#	tween.start()
