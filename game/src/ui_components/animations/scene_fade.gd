# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SceneFade
extends ColorRect

const DURATION: float = 0.6


func fade_in() -> void:
	modulate = Color.BLACK
	show()
	var tween: Tween
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DURATION)


func fade_out() -> void:
	modulate = Color.TRANSPARENT
	show()
	var tween: Tween
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, DURATION)

