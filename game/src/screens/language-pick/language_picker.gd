# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control




func _on_english_pressed() -> void:
	Config.set_lang("en")
	next_screen()


func _on_portuguese_pressed() -> void:
	Config.set_lang("pt")
	next_screen()


func _on_italian_pressed() -> void:
	Config.set_lang("it")
	next_screen()


func _on_german_pressed() -> void:
	Config.set_lang("de")
	next_screen()


func _on_spanish_pressed() -> void:
	Config.set_lang("es")
	next_screen()
	
func next_screen() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")

