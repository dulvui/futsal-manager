# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SceneFade
extends ColorRect

const DURATION: float = 0.6

var tween: Tween


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	tween = create_tween()


func fade_in() -> void:
	modulate = Color.BLACK
	show()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DURATION)


func fade_out() -> void:
	modulate = Color.TRANSPARENT
	show()
	tween.tween_property(self, "modulate", Color.BLACK, DURATION)

