# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later

#TODO
# - random name button

extends Control

@onready var nationality:OptionButton = $VBoxContainer/GridContainer/Nat
@onready var m_name:LineEdit = $VBoxContainer/GridContainer/Name
@onready var m_surname:LineEdit = $VBoxContainer/GridContainer/SurName 


func _ready() -> void:
	# TODO add all possible nationalities
	nationality.add_item("IT")
	nationality.add_item("DE")
	nationality.add_item("FR")
	nationality.add_item("BR")

func _on_Back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/screens/menu/menu.tscn")


func _on_Continue_pressed() -> void:
	print(nationality.get_item_text(nationality.selected))
	if m_name.text.length() * m_surname.text.length() > 0:
		var manager:Manager =  Manager.new()
		manager.name = m_name.text
		manager.surname = m_surname.text
		manager.nationality = nationality.get_item_text(nationality.selected)
		Config.reset()
		Config.save_manager(manager)
		get_tree().change_scene_to_file("res://src/screens/team-select/team_select.tscn")
