# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node2D


func move(final_position:Vector2, time:float, is_global_position:bool = false) -> void:
	var tween:Tween = create_tween()
	if is_global_position:
		tween.tween_property(self, "global_position", final_position, time)
	else:
		tween.tween_property(self, "position", final_position, time)
	tween.tween_property(self, "rotation", randf_range(-5,5), time)
