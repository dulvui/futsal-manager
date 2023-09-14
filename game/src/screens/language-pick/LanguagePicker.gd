# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _on_English_pressed() -> void:
	DataSaver.set_lang("en")
	next_screen()


func _on_Portuguese_pressed() -> void:
	DataSaver.set_lang("pt")
	next_screen()


func _on_Italian_pressed() -> void:
	DataSaver.set_lang("it")
	next_screen()


func _on_German_pressed() -> void:
	DataSaver.set_lang("de")
	next_screen()


func _on_Spanish_pressed() -> void:
	DataSaver.set_lang("es")
	next_screen()
	
func next_screen() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/Menu.tscn")
