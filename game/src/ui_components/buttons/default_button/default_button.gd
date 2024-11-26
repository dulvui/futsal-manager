# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later
class_name SfxButton
extends Button


func _ready() -> void:
	set_custom_minimum_size(Vector2(200, 0))
	size_flags_horizontal = SIZE_SHRINK_CENTER


func _on_pressed() -> void:
	print("sfx press")


func _on_focus_entered() -> void:
	print("sfx focus")

