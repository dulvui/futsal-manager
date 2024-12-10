# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SceneFade
extends Panel

const DURATION: float = 0.6

@export var only_once: bool = false

var tween: Tween


func _ready() -> void:
	theme = ThemeUtil.get_active_theme()
	tween = create_tween()


func fade_in() -> void:
	show()
	modulate = Color.WHITE
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DURATION)
	print("FADE IN")


func fade_out() -> void:
	modulate = Color.TRANSPARENT
	tween.tween_property(self, "modulate", Color.WHITE, DURATION)
	await tween.finished
	print("FADE OUT")

