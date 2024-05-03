# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _on_language_picker_language_change() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")
