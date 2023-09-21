# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _ready() -> void:
	$GridContainer/Nat.add_item("IT")
	$GridContainer/Nat.add_item("DE")
	$GridContainer/Nat.add_item("FR")
	$GridContainer/Nat.add_item("BR")


func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_Continue_pressed() -> void:
	print($GridContainer/Nat.get_item_text($GridContainer/Nat.selected))
	if $GridContainer/Name.text.length() * $GridContainer/SurName.text.length() > 0:
		var manager = {
			"name" : $GridContainer/Name.text,
			"surname" :$GridContainer/SurName.text,
			"nationality" : $GridContainer/Nat.get_item_text($GridContainer/Nat.selected)
		}
		Config.reset()
		Config.save_manager(manager)
		get_tree().change_scene_to_file("res://src/screens/team-select/team_select.tscn")
