# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SplashScreen
extends Control


func _ready() -> void:
	if Global.language:
		# get_tree().change_scene_to_file.call_deferred("res://src/screens/menu/menu.tscn")
		Main.change_scene("res://src/screens/menu/menu.tscn")
	else:
		Main.change_scene("res://src/screens/setup_language/setup_language.tscn")
	
	queue_free()
